//
//  DescriptionTableViewCell.swift
//  ClassRankerApp
//
//  Created by Mariana Meriles on 5/6/22.
//
 
import Foundation
import UIKit
import SwiftUI
 
class DescriptionTableViewCell: UITableViewCell {
    let cellPadding = CGFloat(30)
    static let id = "DescriptionTableViewCellIdentifier"
    
    weak var delegate: DescriptionViewController?
    weak var doubleDel: RankViewController?
    var currentCourse: Course?
    
    // basic info
    var nameBackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0)
        view.clipsToBounds = true
        view.layer.cornerRadius = 50
        return view
    }()
    
    var numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Proxima Nova Bold", size: 22.5)
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "ProximaNova-Regular", size: 20)
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    var ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Proxima Nova Bold", size: 30)
        label.textAlignment = .right
        return label
    }()
    
    var favButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Star 1"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    var favCourse = false
    
    // added info
    var restBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        return view
    }()
    
    var descrLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.textColor = .black
        label.font = UIFont(name: "Proxima Nova Bold", size: 17.5)
        return label
    }()
    
    var descrBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    var descrText: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "ProximaNova-Regular", size: 17.5)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    var creditsLabel: UILabel = {
        let label = UILabel()
        label.text = "Credits:"
        label.textColor = UIColor.black
        label.font = UIFont(name: "Proxima Nova Bold", size: 17.5)
        return label
    }()
    
    var credits: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont(name: "ProximaNova-Regular", size: 17.5)
        return label
    }()
    
    var distrLabel: UILabel = {
        let label = UILabel()
        label.text = "Distributions:"
        label.textColor = UIColor.black
        label.font = UIFont(name: "Proxima Nova Bold", size: 17.5)
        return label
    }()
    
    var distrs: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont(name: "ProximaNova-Regular", size: 17.5)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    var overallLabel: UILabel = {
        let label = UILabel()
        label.text = "Overall:"
        label.textColor = UIColor.black
        label.font = UIFont(name: "Proxima Nova Bold", size: 17.5)
        return label
    }()
    
    var overallRating: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont(name: "Proxima Nova Bold", size: 17.5)
        return label
    }()
    
    var workloadLabel: UILabel = {
        let label = UILabel()
        label.text = "Workload:"
        label.textColor = UIColor.black
        label.font = UIFont(name: "ProximaNova-Regular", size: 17.5)
        return label
    }()
    
    var workloadRating: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont(name: "ProximaNova-Regular", size: 17.5)
        return label
    }()
    
    var difficultyLabel: UILabel = {
        let label = UILabel()
        label.text = "Difficulty:"
        label.textColor = UIColor.black
        label.font = UIFont(name: "ProximaNova-Regular", size: 17.5)
        return label
    }()
    
    var difficultyRating: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont(name: "ProximaNova-Regular", size: 17.5)
        return label
    }()
    
    var profLabel: UILabel = {
        let label = UILabel()
        label.text = "Professors:"
        label.textColor = UIColor.black
        label.font = UIFont(name: "Proxima Nova Bold", size: 17.5)
        return label
    }()
    
    var profs: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont(name: "ProximaNova-Regular", size: 17.5)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    var linkLabel: UILabel = {
        let label = UILabel()
        label.text = "Go to CUReviews"
        label.textColor = UIColor(red: 0.16, green: 0.57, blue: 0.76, alpha: 1.00)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    var linkButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    @objc func goToWebsite(sender: AnyObject) {
        var url = "https://www.cureviews.org/course/\(String(describing: currentCourse?.subject))/\(String(describing: currentCourse?.number))"
        url = url.replacingOccurrences(of: "Optional", with: "")
        url = url.replacingOccurrences(of: "(", with: "")
        url = url.replacingOccurrences(of: ")", with: "")
        url = url.replacingOccurrences(of: "\"", with: "")
        UIApplication.shared.open(URL(string: url)!)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        selectionStyle = .none
        for subView in [nameBackView, numberLabel, nameLabel, ratingLabel, favButton, restBackView, descrLabel, descrBackView, descrText, creditsLabel, credits, distrLabel, distrs, overallLabel, overallRating, workloadLabel, workloadRating, difficultyLabel, difficultyRating, profLabel, profs, linkLabel, linkButton] {
            subView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(subView)
        }
        favButton.addTarget(self, action: #selector(favorite), for: .touchUpInside)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            nameBackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: -20),
            nameBackView.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 100),
            nameBackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            nameBackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
            favButton.leadingAnchor.constraint(equalTo: nameBackView.leadingAnchor, constant: 30),
            favButton.centerYAnchor.constraint(equalTo: numberLabel.centerYAnchor),
            favButton.widthAnchor.constraint(equalToConstant: 20),
            favButton.heightAnchor.constraint(equalToConstant: 20),
            
            numberLabel.bottomAnchor.constraint(equalTo: ratingLabel.bottomAnchor),
            numberLabel.leadingAnchor.constraint(equalTo: favButton.trailingAnchor, constant: 10),
            numberLabel.trailingAnchor.constraint(equalTo: ratingLabel.leadingAnchor, constant: -30),
            
            nameLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: nameBackView.leadingAnchor, constant: 30),
            nameLabel.trailingAnchor.constraint(equalTo: nameBackView.trailingAnchor, constant: -30),
            
            ratingLabel.topAnchor.constraint(equalTo: nameBackView.topAnchor, constant: 15),
            ratingLabel.trailingAnchor.constraint(equalTo: nameBackView.trailingAnchor, constant: -35),
            
            restBackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 15),
            restBackView.leadingAnchor.constraint(equalTo: nameBackView.leadingAnchor),
            restBackView.trailingAnchor.constraint(equalTo: nameBackView.trailingAnchor),
            restBackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            
            descrLabel.topAnchor.constraint(equalTo: restBackView.topAnchor, constant: 15),
            descrLabel.leadingAnchor.constraint(equalTo: restBackView.leadingAnchor, constant: 15),
            
            descrBackView.topAnchor.constraint(equalTo: descrLabel.bottomAnchor, constant: 5),
            descrBackView.bottomAnchor.constraint(equalTo: descrText.bottomAnchor, constant: 10),
            descrBackView.leadingAnchor.constraint(equalTo: restBackView.leadingAnchor, constant: 10),
            descrBackView.trailingAnchor.constraint(equalTo: restBackView.trailingAnchor, constant: -10),
            
            descrText.topAnchor.constraint(equalTo: descrBackView.topAnchor, constant: 10),
            descrText.leadingAnchor.constraint(equalTo: descrBackView.leadingAnchor, constant: 10),
            descrText.trailingAnchor.constraint(equalTo: descrBackView.trailingAnchor, constant: -10),
            
            creditsLabel.topAnchor.constraint(equalTo: descrBackView.bottomAnchor, constant: 15),
            creditsLabel.leadingAnchor.constraint(equalTo: descrLabel.leadingAnchor),
            
            credits.topAnchor.constraint(equalTo: creditsLabel.topAnchor),
            credits.leadingAnchor.constraint(equalTo: creditsLabel.trailingAnchor, constant: 10),
            
            distrLabel.topAnchor.constraint(equalTo: credits.bottomAnchor, constant: 15),
            distrLabel.leadingAnchor.constraint(equalTo: descrLabel.leadingAnchor),
            
            distrs.topAnchor.constraint(equalTo: distrLabel.bottomAnchor),
            distrs.leadingAnchor.constraint(equalTo: distrLabel.leadingAnchor),
            distrs.trailingAnchor.constraint(equalTo: overallLabel.leadingAnchor, constant: -15),
            
            overallLabel.topAnchor.constraint(equalTo: creditsLabel.topAnchor),
            overallLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: contentView.bounds.width/2 + 20),
            
            overallRating.topAnchor.constraint(equalTo: overallLabel.topAnchor),
            overallRating.trailingAnchor.constraint(equalTo: restBackView.trailingAnchor, constant: -20),
            
            workloadLabel.topAnchor.constraint(equalTo: overallLabel.bottomAnchor),
            workloadLabel.leadingAnchor.constraint(equalTo: overallLabel.leadingAnchor),
            
            workloadRating.topAnchor.constraint(equalTo: workloadLabel.topAnchor),
            workloadRating.trailingAnchor.constraint(equalTo: overallRating.trailingAnchor),
            
            difficultyLabel.topAnchor.constraint(equalTo: workloadLabel.bottomAnchor),
            difficultyLabel.leadingAnchor.constraint(equalTo: overallLabel.leadingAnchor),
            
            difficultyRating.topAnchor.constraint(equalTo: difficultyLabel.topAnchor),
            difficultyRating.trailingAnchor.constraint(equalTo: overallRating.trailingAnchor),
            
            linkButton.topAnchor.constraint(equalTo: difficultyLabel.bottomAnchor, constant: -5),
            linkButton.leadingAnchor.constraint(equalTo: overallLabel.leadingAnchor),
            
            linkLabel.centerXAnchor.constraint(equalTo: linkButton.centerXAnchor),
            linkLabel.centerYAnchor.constraint(equalTo: linkButton.centerYAnchor),
            linkLabel.leadingAnchor.constraint(equalTo: linkButton.leadingAnchor),
            
            profLabel.topAnchor.constraint(equalTo: linkLabel.bottomAnchor, constant: 15),
            profLabel.leadingAnchor.constraint(equalTo: overallLabel.leadingAnchor),
            
            profs.topAnchor.constraint(equalTo: profLabel.bottomAnchor),
            profs.leadingAnchor.constraint(equalTo: profLabel.leadingAnchor),
            profs.trailingAnchor.constraint(equalTo: restBackView.trailingAnchor, constant: -10),
            profs.bottomAnchor.constraint(equalTo: restBackView.bottomAnchor, constant: -15)
        ])
    }
    
    @objc func favorite() {
        if Globals.guest.boolValue == true {
            let alert = UIAlertController(title: "Please Login", message: nil, preferredStyle: .alert)
            alert.view.tintColor = .darkGray
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            return
        }
        if favCourse == false {
            favButton.setImage(UIImage(named: "Star 2"), for: .normal)
            favCourse = true
            doubleDel?.isFavoriteCourse(course: currentCourse!, favorite: true)
        }
        else if favCourse == true {
            favButton.setImage(UIImage(named: "Star 1"), for: .normal)
            favCourse = false
            doubleDel?.isFavoriteCourse(course: currentCourse!, favorite: false)
        }
    }
    
    func configure(course: Course) {
        currentCourse = course
        currentCourse?.subject = course.subject
        currentCourse?.number = course.number
        let courseNumber = course.subject + " " + String(course.number)
        numberLabel.text = courseNumber
        nameLabel.text = course.title
        let rating = round(course.rating * 10) / 10.0
        ratingLabel.text = String(rating)
        descrText.text = course.description
        credits.text = String(course.creditsMin)
        //self.reqs.text = course.reqs
        
        let distrArray = course.distributions
        let distrNames = distrArray.map { $0.name }
        self.distrs.text = distrNames.joined(separator: ", ")
        
        overallRating.text = String(rating)
        let workload = round(course.workload * 10) / 10.0
        workloadRating.text = String(workload)
        let difficulty = round(course.difficulty * 10) / 10.0
        difficultyRating.text = String(difficulty)
        
        let profArray = course.professors
        let profNames = profArray.map { $0.first_name + " " + $0.last_name }
        profs.text = profNames.joined(separator: " ")
        favCourse = course.favorite ?? false
        if Globals.favCourses.contains(course) {
            favCourse = true
        }
        if favCourse == true {
            print("true")
            favButton.setImage(UIImage(named: "Star 2"), for: .normal)
        } else {
            print("false")
            favButton.setImage(UIImage(named: "Star 1"), for: .normal)
        }
        linkButton.addTarget(self, action: #selector(goToWebsite), for: .touchUpInside)
    }
}
