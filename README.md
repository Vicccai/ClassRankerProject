# Class Rooster
Feeling lost? Tired of swapping tabs? Don't wing it. Use Class Rooster!

# Description
Imagine this: you're looking for a course to fulfill a requirement, but nothing seems to match your interests. You've looked through 30 out of 65 results on Course Roster and you've already opened 10 syllabuses and 7 CUReviews tabs. Preferably, the class you're looking for is easy, but you also want a rewarding experience overall. How much long will it take to find this class? Hours? Not if you use Class Rooster! With Class Rooster, we've optimized this process to find your dream class within a couple of simple clicks. You can filter courses by college, level, requirements, rating, difficulty, and workload. These filters can be mixed and matched and you can even favorite these courses or leave comments. There's no need to wing course registration with Class Rooster!

App Store: https://apps.apple.com/us/app/class-rooster/id1630680209

Members: 
Jordan Han (back-end),
Bryan Lee (back-end),
Luke Leh (product-design),
Victor Cai (front-end),
Mariana Meriles (front-end),
Young Zheng (full-stack)

# Screenshots
<img src="https://user-images.githubusercontent.com/69128074/175114319-f315e77b-aef1-44e0-964a-1842ec151150.png" width="500">
<img src="https://user-images.githubusercontent.com/69128074/175114365-ebeff883-8007-426c-9a06-453b0dcb470a.png" width="500">
<img src="https://user-images.githubusercontent.com/69128074/175114440-e07b2790-561c-4655-aef1-a65bd8c85907.png" width="500">
<img src="https://user-images.githubusercontent.com/69128074/176251150-8d3548aa-e1ae-4e13-ba98-48dc3583b21f.png" width="500">
<img src="https://user-images.githubusercontent.com/69128074/175114475-8ee0f210-cdaa-480e-9653-fe6e728055d4.png" width="500">

# Front-end Implemention
* Developed using Swift, SwiftUI and UIKit
* Downloaded Alamofire, IQKeyboardManagerSwift and iOSDropDown using CocoaPods
* Features 
  * Search bar based on course title
  * Filter by college, course level, distribution
  * Sort by course rating, which includes overall, difficulty and workload
  * User and guest login
  * Favorite courses, display all favorites, and search favorites
  * Discussion forums for every course
  * Each course displays its rating and description
  
# Figma
https://www.figma.com/file/qPlbhnlE9x49FaDMPc8DeR/Hack-Challenge-SP22?node-id=0%3A1

# Back-end Implementation
* Developed using Flask, SQLAlchemy and Python
* Tested using Postman
* Scraped [CUReviews](https://www.cureviews.org/), [Rate My Professors](https://www.ratemyprofessors.com/) and utilized [Class Roster](https://classes.cornell.edu/browse/roster/FA22) API to generate data for Course, Breadth, Distribution and Professor tables
* Added one-to-many relationship to User and Comment tables and many-to-many relationships to User and Course, Professor and Course, Breadth and Course, and Distribution and Course tables
* Optimized filter times using pre-sorted tables; reduced search time on Google Cloud's e2-small vm from 6-7 seconds to <2 sec
* Created endpoint to routinely update tables with new data
* Implemented http token authentication with bcrypt library
* Containerized with Docker and deployed using Google Cloud virtual machine

# How to run
* Clone to repository
* Open with Xcode
* Select ClassRankerApp.xcworkspace
* Select iPhone/iPad device
* Click run

# Credits
Thank you Cornell DTI for letting us scrape CUReviews and Cornell University for access to the Class Roster API. Also, thank you Gonzalo Gonzalez for being the best mentor ever!
