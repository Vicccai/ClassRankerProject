from cgitb import reset
from curses import resize_term
import datetime
import json
import math
from flask import Flask, request
from db import SortedByDifficulty, SortedByRating, SortedByWorkload, db, Course, User, Professor, Comment, Breadth, Distribution
import requests
import users_dao

app = Flask(__name__)
db_filename = "data.db"

app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///%s" % db_filename
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["SQLALCHEMY_ECHO"] = True

db.init_app(app)
with app.app_context():  
    db.create_all()

def failure_response(message, code=404):
    return json.dumps({"success": False, "error": message}), code

def success_response(data, code=200):
    """
    Generalized success response function
    """
    return json.dumps(data), code
    
def get_rosters():
    """
    Gives last 4 of the available rosters (FA22, SP20 etc)
    """
    uri = "https://classes.cornell.edu/api/2.0/config/rosters.json"
    reqResponse = requests.get(url=uri)
    rosters = reqResponse.json()["data"]["rosters"]
    roster_list = []
    for roster in rosters:
        roster_list.append(roster["slug"])
    roster_list = roster_list[len(roster_list)-5:]
    return roster_list

def get_subjects(roster):
    """
    Gives all of the subjects of a given roster in a list
    """
    uri = "https://classes.cornell.edu/api/2.0/config/subjects.json?roster=" + roster 
    reqResponse = requests.get(url=uri)
    subjects = reqResponse.json()["data"]["subjects"]
    subject_list = []
    for subject in subjects:
        subject_list.append(subject["value"])
    return subject_list

def get_course_rating(subject, number):
    """
    Given subject (cs, engl, etc.) and number (1110, 4820, etc.) gives the difficulty of the class from CUReviews
    """
    body = {"number":number, "subject":subject}
    uri = "https://www.cureviews.org/v2/getCourseByInfo"
    reqResponse = requests.post(url=uri, json=body)
    results = reqResponse.json()["result"]
    if results is None:
        return {
            "difficulty": 0.0,
            "rating": 0.0,
            "workload": 0.0
        }
    difficulty = results.get("classDifficulty")
    if(difficulty is None):
        difficulty = "0"
    rating = results.get("classRating")
    if(rating == "" or rating is None):
        rating = "0"
    workload = results.get("classWorkload")
    if(workload is None):
        workload = "0"
    ratings = {
        "difficulty": float(difficulty),
        "rating": float(rating),
        "workload": float(workload)
    }
    return ratings

def get_professor_rating(Cornell_University, first_name, last_name):
    """
    Given first and last name, gives professor name and rating
    """
    prof = Cornell_University.get_professor_by_name(first_name, last_name)
    if prof is None:
        rating = 0.0
    else:
        rating = prof.overall_rating
    return rating

def get_professor(course):
    """
    Given course returns a list of professors.
    """
    meetings = course["enrollGroups"][0]["classSections"][0]["meetings"]
    if len(meetings) == 0:
        return []
    instructors = meetings[0]["instructors"]
    if len(instructors) == 0:
        return []
    prof_list = []
    for prof in instructors:
        prof_list.append([prof["firstName"], prof["lastName"]])
    return prof_list

def get_courses(roster, subject):
    """
    Given roster (FA22, SP20, etc.) and subject (CS, ENGL, etc.) gives important information about the course
    """
    uri = "https://classes.cornell.edu/api/2.0/search/classes.json?roster=" + roster + "&subject=" + subject
    reqResponse = requests.get(url=uri)
    classes = reqResponse.json()["data"]["classes"]
    course_list = []
    for course in classes:
        course_list.append(
            {
                "subject": course["subject"],
                "number": int(course["catalogNbr"]),
                "title": course["titleLong"],
                "description": course["description"],
                "breadth": course["catalogBreadth"],
                "distribution": course["catalogDistr"],
                "creditsMin": course["enrollGroups"][0]["unitsMinimum"],
                "creditsMax": course["enrollGroups"][0]["unitsMaximum"],
                "professors": get_professor(course)
            }
        )
    return course_list

def convert_to_list(dist):
    """
    Helper method to convert distribution and breadth into a list format
    """
    if dist == "":
        return []
    i = 1
    list = []
    while(dist.find(",", i) != -1):
        list += [dist[i: dist.find(",", i)].strip()]
        i = dist.find(",", i)+1
    list += [dist[i:-1].strip()]
    return list

def add_professors_to_course(course, professors):
    """
    Given list of professors adds them to the course 
    """
    for prof in professors:
        found = False
        for course_prof in course.professors:
            if(course_prof.first_name == prof[0] and course_prof.last_name == prof[1]):
                found = True
        if(not found):
            prev_prof = Professor.query.filter_by(first_name=prof[0],last_name=prof[1]).first()
            if(prev_prof is None):
                prev_prof = Professor(first_name=prof[0],
                                    last_name=prof[1],
                                    full_name=prof[0] + " " + prof[1])
            course.professors.append(prev_prof) 

def add_breadths_to_course(course, breadths):
    """
    Given strings of breadths, add them to the course
    """
    breadth_list = convert_to_list(breadths)
    for breadth in breadth_list:
        found = False
        for course_breadth in course.breadths:
            if(course_breadth.name == breadth):
                found = True
        if(not found):
            prev_breadth = Breadth.query.filter_by(name=breadth).first()
            if(prev_breadth is None):
                prev_breadth = Breadth(name=breadth)
            course.breadths.append(prev_breadth)

def add_distributions_to_course(course, distributions):
    """
    Given strings of distributions, add them to the course
    """
    distribution_list = convert_to_list(distributions)
    for distribution in distribution_list:
        found = False
        for course_distribution in course.distributions:
            if(course_distribution.name == distribution):
                found = True
        if(not found):
            prev_distribution = Distribution.query.filter_by(name=distribution).first()
            if(prev_distribution is None):
                prev_distribution = Distribution(name=distribution)
            course.distributions.append(prev_distribution)

@app.route("/setup_update/")
def set_up_and_update_courses():
    """
    Adds and updates all of the courses of the last four semesters to the Course table. 
    """
    Professor.query.delete()
    Breadth.query.delete()
    Distribution.query.delete()
    SortedByRating.query.delete()
    SortedByDifficulty.query.delete()
    SortedByWorkload.query.delete()
    course_0 = Course.query.filter_by(id=1).first()
    if course_0 is None:
        new_course = Course(
            subject = "No courses here",
            number = 0,
            subandnum = "No courses here",
            title = "Try some new filters!",
            creditsMin = 0,
            creditsMax = 0,
            description = "Psychiatrist: What seems to be the problem? Patient: I think I'm a chicken. Psychiatrist: How long has this been going on? Patient: Ever since I came out of my shell.",
            workload = 0,
            difficulty = 0,
            rating = 0
            )
        db.session.add(new_course)
    rosters = get_rosters()
    #rosters = ["FA22"]
    for roster in rosters:
        subjects = get_subjects(roster)
        #subjects = ["CS"]
        for subject in subjects:
            courses = get_courses(roster, subject)
            for course in courses:
                prev_course = Course.query.filter_by(title=course["title"]).first()
                description = course["description"] if course["description"] is not None else "No Description Found."
                breadth = course["breadth"] if course["breadth"] is not None else ""
                distribution = course["distribution"] if course["distribution"] is not None else ""
                rating = get_course_rating(course["subject"].lower(), course["number"])
                if prev_course is None:
                    new_course = Course(
                        subject = course["subject"],
                        number = course["number"],
                        subandnum = course["subject"] + " " + str(course["number"]),
                        title = course["title"],
                        creditsMin = course["creditsMin"],
                        creditsMax = course["creditsMax"],
                        description = description,
                        workload = rating["workload"],
                        difficulty = rating["difficulty"],
                        rating = rating["rating"]
                        )
                    add_professors_to_course(new_course, course["professors"])
                    add_breadths_to_course(new_course, breadth)
                    add_distributions_to_course(new_course, distribution)
                    db.session.add(new_course)
                else:
                    prev_course.description = description
                    prev_course.workload = rating["workload"]
                    prev_course.difficulty = rating["difficulty"]
                    prev_course.rating = rating["rating"]
                    add_professors_to_course(prev_course, course["professors"])
                    add_breadths_to_course(prev_course, breadth)
                    add_distributions_to_course(prev_course, distribution)
                db.session.commit()
    sort_courses()
    return json.dumps({"courses": [c.serialize() for c in Course.query.all()]})

def sort_by_rating(course):
    """
    Function to specify sorting criteria for ratings
    """
    rating = course.rating
    return rating if rating > 0 else -1

def sort_by_difficulty(course):
    """
    Function to specify sorting criteria for difficulty
    """
    difficulty = course.difficulty
    return difficulty if difficulty > 0 else 6

def sort_by_workload(course):
    """
    Function to specify sorting criteria for workload
    """
    workload = course.workload
    return workload if workload > 0 else 6

def sort_courses():
    """
    Loops through the table of courses and sorts them by rating, workload and difficulty. Adds the sorted lists to their respective tables
    """
    course_list = []
    for c in Course.query.all():
        course_list.append(c)
    course_list.sort(reverse=True, key=sort_by_rating)
    for c in course_list:
        new_course = SortedByRating(
            course_id = c.id,
            subject = c.subject,
            number = c.number,
            subandnum = c.subandnum,
            title = c.title,
            creditsMin = c.creditsMin,
            creditsMax = c.creditsMax,
            description = c.description,
            workload = c.workload,
            difficulty = c.difficulty,
            rating = c.rating
        )
        for b in c.breadths:
            new_course.breadths.append(b)
        for d in c.distributions:
            new_course.distributions.append(d)
        for p in c.professors:
            new_course.professors.append(p)
        for cm in c.comments:
            cm.sortedByRating_subandnum = c.subandnum
        db.session.add(new_course)
    db.session.commit()
    course_list.sort(key=sort_by_workload)
    for c in course_list:
        new_course = SortedByWorkload(
            course_id = c.id,
            subject = c.subject,
            number = c.number,
            subandnum = c.subandnum,
            title = c.title,
            creditsMin = c.creditsMin,
            creditsMax = c.creditsMax,
            description = c.description,
            workload = c.workload,
            difficulty = c.difficulty,
            rating = c.rating
        )
        for b in c.breadths:
            new_course.breadths.append(b)
        for d in c.distributions:
            new_course.distributions.append(d)
        for p in c.professors:
            new_course.professors.append(p)
        for cm in c.comments:
            cm.sortedByWorkload_subandnum = c.subandnum
        db.session.add(new_course)
    db.session.commit()
    course_list.sort(key=sort_by_difficulty)
    for c in course_list:
        new_course = SortedByDifficulty(
            course_id = c.id,
            subject = c.subject,
            number = c.number,
            subandnum = c.subandnum,
            title = c.title,
            creditsMin = c.creditsMin,
            creditsMax = c.creditsMax,
            description = c.description,
            workload = c.workload,
            difficulty = c.difficulty,
            rating = c.rating
        )
        for b in c.breadths:
            new_course.breadths.append(b)
        for d in c.distributions:
            new_course.distributions.append(d)
        for p in c.professors:
            new_course.professors.append(p)
        for cm in c.comments:
            cm.sortedByDifficulty_subandnum = c.subandnum
        db.session.add(new_course)
    db.session.commit()

def list_helper_for_any(distribution, sort):
    """
    Helper function to find courses that fulfills any distributions
    """
    sorted_courses = []
    for d in distribution:
        sorted_courses += Distribution.query.filter_by(name=d).first().sortedByRating
    if sort == 1:
        sorted_courses.sort(reverse=True, key=sort_by_rating)
    elif sort == 2:
        sorted_courses.sort(key=sort_by_difficulty)
    else:
        sorted_courses.sort(key=sort_by_workload)
    return sorted_courses

def list_helper_for_all(distribution, sort):
    """
    Helper function to find courses that fulfills all distributions
    """
    sorted_courses = Distribution.query.filter_by(name=distribution[0]).first().sortedByRating
    for i in range(1,len(distribution)):
        c = Distribution.query.filter_by(name = distribution[i]).first().sortedByRating
        sorted_courses = list(set(sorted_courses).intersection(c))
    if sort == 1:
        sorted_courses.sort(reverse=True, key=sort_by_rating)
    elif sort == 2:
        sorted_courses.sort(key=sort_by_difficulty)
    else:
        sorted_courses.sort(key=sort_by_workload)
    return sorted_courses

def list_helper_for_none(sort):
    """
    Helper function to find courses that fulfills no distributions
    """
    if sort == 1:
        return SortedByRating.query.all()
    elif sort == 2:
        return SortedByDifficulty.query.all()
    else:
        return SortedByWorkload.query.all()

def list_helper_for_one(distribution, sort):
    """
    Helper function to find courses that fulfills one distribution
    """
    dist = Distribution.query.filter_by(name=distribution[0]).first()
    if sort == 1:
        return dist.sortedByRating
    elif sort == 2:
        return dist.sortedByDifficulty
    else:
        return dist.sortedByWorkload

def strip_dist_helper(distribution):
    """
    Helper function to strip the title from the distribution
    """
    res = []
    for d in distribution:
        if d.find("CE-AS") != -1:
            res.append("CE-EN")
        elif d.find("LAD-AS") != -1:
            res.append("LAD-HE")
        else:
            res.append(d)
    return res

@app.route("/courses/attributes/", methods = ["POST"])
def get_sorted_courses():
    """
    Takes in a JSON dictionary and it is an endpoint for getting courses sorted by the listed attributes.
     
    For the subject attribute, it can be the empty string if there is no specified subject
    For the level attribute, it can be 0 if there is no specified level, else it will be X000
    For the breadth and distribution attribute, it can be the empty list if there is no specified elements
    For the all attribute, if it is true, it will return courses with all the dist/breadth if it is false, then it will return courses with any
    For the sort attribute, it can sorted 4 different ways, input can be 1, 2, 3:
        1 is sorting by best to worst rating
        2 is sorting by least to most difficulty
        3 is sorting by least to most workload
    """
    body = json.loads(request.data)
    subject = body.get("subject")
    level = body.get("level")
    distribution = strip_dist_helper(body.get("distribution"))
    all = body.get("all")
    sort = body.get("sort")
    if subject is None or level is None or distribution is None or all is None or sort is None:
        return failure_response("Required field(s) not supplied.", 400)
    if not isinstance(sort, int) or sort < 1 or sort > 3:
        return failure_response("Invalid input for sort.", 400)
    course_0 = Course.query.filter_by(id=1).first()
    if level == 0 and distribution == []:
        return json.dumps({"courses": [course_0.serialize()]}), 200
    sorted_courses = []
    if len(distribution) == 0:
        dist_courses = list_helper_for_none(sort)
    elif len(distribution) == 1:
        dist_courses = list_helper_for_one(distribution,sort)
    elif not all:
        dist_courses = list_helper_for_any(distribution, sort)
    else:
        dist_courses = list_helper_for_all(distribution, sort)
    for c in dist_courses:
        if(len(sorted_courses) > 200):
            break
        if c.course_id != 1 and (c.subject == subject or subject == ""):
            if math.floor(c.number / 1000) == math.floor(level / 1000) or level == 0:
                sorted_courses.append(c) 
    if(len(sorted_courses) == 0):
        return json.dumps({"courses": [course_0.serialize()]}), 200
    return json.dumps({"courses": [c.serialize() for c in sorted_courses]}), 200


@app.route("/courses/")
def get_all_courses():
    """
    Endpoint for getting all courses
    """
    course_0 = Course.query.filter_by(id=1).first()
    return json.dumps({"courses": [course_0.serialize()]}), 200
    #return json.dumps({"courses": [c.serialize() for c in SortedByRating.query.all()]}), 200

#Endpoints for authentication
def extract_token(request):
    """
    Helper function that extracts the token from the header of a request
    """
    auth_header = request.headers.get("Authorization")
    if auth_header is None:
        return False, failure_response("Missing authorization header")
    
    bearer_token = auth_header.replace("Bearer", "").strip()

    return True, bearer_token

@app.route("/register/", methods=["POST"])
def register_account():
    """
    Endpoint for registering a new user
    """
    body = json.loads(request.data)
    username = body.get("username")
    password = body.get("password")

    if username is None or password is None:
        return failure_response("Missing username or password")
    
    was_successful, user = users_dao.create_user(username, password)
    
    if not was_successful:
        return failure_response("User already exists")
    
    return success_response({
        "username": username,
        "session_token": user.session_token,
        "session_expiration": str(user.session_expiration),
        "update_token": user.update_token
    }, 201)

@app.route("/login/", methods=["POST"])
def login():
    """
    Endpoint for logging in a user
    """
    body = json.loads(request.data)
    username = body.get("username")
    password = body.get("password")

    if username is None or password is None:
        return failure_response("Missing username or password", 400)

    if User.query.filter_by(username=username).first() is None:
        return failure_response("User does not exist")

    was_successfull, user = users_dao.verify_credentials(username, password)

    if not was_successfull:
        return failure_response("Incorrect username or password", 401)
    
    users_dao.renew_session(user.update_token)

    return success_response(
        {
            "username": username,
            "session_token": user.session_token,
            "session_expiration": str(user.session_expiration),
            "update_token": user.update_token
        }
    )

@app.route("/logout/", methods=["POST"])
def logout():
    """
    Endpoint for logging out a user
    """
    was_successful, session_token = extract_token(request)

    if not was_successful:
        return session_token
    
    user = users_dao.get_user_by_session_token(session_token)

    if not user or not user.verify_session_token(session_token):
        return failure_response("Invalid session token")
    
    user.session_expiration = datetime.datetime.now()
    db.session.commit()

    return success_response(
        {
            "username": user.username,
            "session_token": user.session_token,
            "session_expiration": str(user.session_expiration),
            "update_token": user.update_token
        }
    )

@app.route("/users/")
def get_users():
    """
    Endpoint for getting all users
    """
    return json.dumps({"users": [u.simple_serialize() for u in User.query.all()]}), 200

# Endpoints for favorite courses
@app.route("/favorites/")
def get_favorites():
    """
    Endpoint for retrieving user's favorited courses by sesion_token
    """

    was_successful, session_token = extract_token(request)

    if not was_successful:
        return session_token
    
    user = users_dao.get_user_by_session_token(session_token)

    if user is None or not user.verify_session_token(session_token):
        return failure_response("Invalid session token")

    courses = []
    for c in user.courses:
        if c.id != 1:
            courses.append(c)
    return json.dumps({"favorites": [f.serialize() for f in courses]}), 200

@app.route("/add/favorites/", methods = ["POST"])
def add_to_favorites():
    """
    Endpoint for adding to a user's favorites courses
    """
    was_successful, session_token = extract_token(request)
    if not was_successful:
        return session_token
    
    user = users_dao.get_user_by_session_token(session_token)

    if user is None or not user.verify_session_token(session_token):
        return failure_response("Invalid session token")
    
    body = json.loads(request.data)
    course_id = body.get("course_id")
    if course_id is None:
        return failure_response("Required field(s) not provided.", 400)
    course = Course.query.filter_by(id=course_id).first()
    course_rating = SortedByRating.query.filter_by(subandnum=course.subandnum).first()
    course_difficulty = SortedByDifficulty.query.filter_by(subandnum=course.subandnum).first()
    course_workload = SortedByWorkload.query.filter_by(subandnum=course.subandnum).first()
    if course is None:
        return failure_response("Course not found.")
    for c in user.courses:
        if c.id == course_id:
            return failure_response("Course is already liked")
    user.courses.append(course)
    user.sortedByRating.append(course_rating)
    user.sortedByDifficulty.append(course_difficulty)
    user.sortedByWorkload.append(course_workload)
    db.session.commit()
    return json.dumps(course.serialize()), 200

@app.route("/delete/favorites/", methods = ["POST"])
def delete_from_favorites():
    """
    Enpoint for deleting a course from user's favorites
    """
    was_successful, session_token = extract_token(request)

    if not was_successful:
        return session_token
    
    user = users_dao.get_user_by_session_token(session_token)

    if user is None or not user.verify_session_token(session_token):
        return failure_response("Invalid session token")

    body = json.loads(request.data)
    course_id = body.get("course_id")
    course = None
    for c in user.courses:
        if c.id == course_id:
            course = c
    if course is None:
        return failure_response("Course not found.")
    course_rating = SortedByRating.query.filter_by(subandnum=course.subandnum).first()
    course_difficulty = SortedByDifficulty.query.filter_by(subandnum=course.subandnum).first()
    course_workload = SortedByWorkload.query.filter_by(subandnum=course.subandnum).first()
    user.courses.remove(course)
    user.sortedByRating.remove(course_rating)
    user.sortedByDifficulty.remove(course_difficulty)
    user.sortedByWorkload.remove(course_workload)
    db.session.commit()
    return json.dumps(course.serialize()), 200

# Endpoints related to comments
@app.route("/courses/comments/<int:course_id>/")
def get_comments_by_course(course_id):
    """
    Endpoint for retrieving comments by course id 
    """
    course = Course.query.filter_by(id= course_id).first()
    if course is None:
        return failure_response("Course not found.")
    return json.dumps({"comments": [c.serialize() for c in course.comments]}), 200

@app.route("/users/comments/")
def get_comments_by_user():
    """
    Endpoint for retrieving comments by session_token
    """

    was_successful, session_token = extract_token(request)

    if not was_successful:
        return session_token
    
    user = users_dao.get_user_by_session_token(session_token)

    if user is None or not user.verify_session_token(session_token):
        return failure_response("Invalid session token")
    
    return json.dumps({"comments": [u.serialize() for u in user.comments]}), 200

@app.route("/comments/", methods = ["POST"])
def post_comment(): 
    """
    Endpoint for posting comments to a course
    """
    was_successful, session_token = extract_token(request)

    if not was_successful:
        return session_token
    
    user = users_dao.get_user_by_session_token(session_token)

    if user is None or not user.verify_session_token(session_token):
        return failure_response("Invalid session token")

    body = json.loads(request.data)
    course_id = body.get("course_id")
    description = body.get("description")
    username = body.get("username")
    if course_id is None or description is None or username is None:
        return failure_response("Required field(s) not supplied.", 400)
    if description == "":
        return failure_response("Description must be provided.", 400)

    course = Course.query.filter_by(id= course_id).first()
    if course is None:
        return failure_response("Course not found.")
    new_comment = Comment(
        course_id= course_id, 
        subandnum = course.subandnum,
        username = username,
        description = description
    )
    db.session.add(new_comment)
    db.session.commit()
    return json.dumps(new_comment.serialize()), 201

@app.route("/comments/<int:comment_id>/", methods = ["DELETE"])
def delete_comment(comment_id):
    """
    Endpoint for deleting comments 
    """
    was_successful, session_token = extract_token(request)

    if not was_successful:
        return session_token
    
    user = users_dao.get_user_by_session_token(session_token)

    if user is None or not user.verify_session_token(session_token):
        return failure_response("Invalid session token")

    comment = Comment.query.filter_by(id= comment_id).first()
    if comment is None:
        return failure_response("Comment not found.")
    db.session.delete(comment)
    db.session.commit()
    return json.dumps(comment.serialize()), 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)