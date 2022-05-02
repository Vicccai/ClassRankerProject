//
//  ViewController.swift
//  ClassRankerApp
//
//  Created by Victor Cai on 4/28/22.
//

import UIKit
import Alamofire
import iOSDropDown
//import DropDown

class RankViewController: UIViewController {
    
    let padding: CGFloat = 15
    
    let courses = [
        Course(number: "CS 1110", name: "Intro to Python", rating: 9.7, distribution: ["MQR-AS"], favNumber: 102),
        Course(number: "CS 2110", name: "Object Oriented Programming", rating: 8.4, distribution: ["MQR-AS"], favNumber: 201),
        Course(number: "MATH 1110", name: "Calc 1", rating: 4.2, distribution: [
        "MQR-AS"], favNumber: 301),
        Course(number: "CS 1234", name: "Made up CS LA-AS", rating: 4.2, distribution: [
        "LA-AS"], favNumber: 301)
    ]
    
    var filteredCourses: [Course] = [] // based on SearchBar
    
    var selectedMajor: String = ""
    var selectedDistr: String = ""
    
    var shownCourses: [Course] = [] // courses that are actually shown, combo of search and dropdown
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    var filterCollection: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.scrollDirection = .horizontal
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return collectionView
    }()
    
   
    lazy var coursesView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CoursesTableViewCell.self, forCellReuseIdentifier: CoursesTableViewCell.id)
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        return tableView
    }()
    
    var majorDropDown: DropDownContainer = {
        let view = DropDownContainer(placeholder: "Select Major", optionArray: ["", "CS", "MATH"])
        return view
    }()

    var distrDropDown: DropDownContainer = {
        let view = DropDownContainer(placeholder: "Select Distribution", optionArray:  ["", "MQR-AS", "LA-AS"])
        return view
    }()
    
//    let majorView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .white
//        view.layer.cornerRadius = 10
//        return view
//    }()
//
//    let distrView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .white
//        view.layer.cornerRadius = 10
//        return view
//    }()
//
//    var majorDropDown: DropDown = {
//        let dropDown = DropDown()
//        dropDown.dataSource = ["", "CS", "MATH", "test", "hi", "bye", "hello"]
//        dropDown.cornerRadius = 10
//        dropDown.selectedTextColor = UIColor.red
//        return dropDown
//    }()
//
//    var distrDropDown: DropDown = {
//        let dropDown = DropDown()
//        dropDown.dataSource = ["MQR-AS", "LA-AS"]
//        dropDown.cornerRadius = 10
//        return dropDown
//    }()
    
//    var applyButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("  Apply  ", for: .normal)
//        button.setTitleColor(.black, for: .normal)
//        button.layer.borderWidth = 1
//        button.backgroundColor = .white
//        button.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1.0)
//        button.layer.cornerRadius = 10
//        button.addTarget(self, action: #selector(pressApply), for: .touchDown)
//        button.addTarget(self, action: #selector(releaseApply), for: .touchUpInside)
//        return button
//    }()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.navigationBar.prefersLargeTitles = true
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = UIColor(red: 0.6, green: 0, blue: 0, alpha: 1.0)
        navigationBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 30, weight: .bold)
        ]
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([.foregroundColor : UIColor.white], for: .normal)
        
        navigationItem.title = "Courses"
        view.backgroundColor = UIColor(red: 0.6, green: 0, blue: 0, alpha: 1.0)
        
        // drop down stuff
        
//        let gesture1 = UITapGestureRecognizer(target: self, action: #selector(selectMajor))
//        gesture1.numberOfTouchesRequired = 1
//        gesture1.numberOfTapsRequired = 1
//        majorView.addGestureRecognizer(gesture1)
//        majorDropDown.anchorView = majorView
//
//        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(selectDistr))
//        gesture2.numberOfTouchesRequired = 1
//        gesture2.numberOfTapsRequired = 1
//        distrView.addGestureRecognizer(gesture2)
//        distrDropDown.anchorView = distrView
        
        for subView in [coursesView, majorDropDown, distrDropDown] {
            view.addSubview(subView)
            subView.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // search bar stuff
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Classes"
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.backgroundColor = UIColor(red: 0.6, green: 0, blue: 0, alpha: 1.0)
        searchController.searchBar.searchTextField.backgroundColor = .systemBackground
        searchController.searchBar.tintColor = .black
        
        navigationItem.searchController = searchController
        definesPresentationContext = false
        
        setupDropdown()
        
        setupConstraints()
        
        calculateShownCourses()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
//            applyButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
//            applyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
//            applyButton.heightAnchor.constraint(equalToConstant: 30),
            
//            majorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
//            majorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
//            majorView.heightAnchor.constraint(equalToConstant: 30),
//            majorView.widthAnchor.constraint(equalToConstant: 100),
//
//            distrView.leadingAnchor.constraint(equalTo: majorView.trailingAnchor, constant: padding),
//            distrView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
//            distrView.heightAnchor.constraint(equalToConstant: 30),
//            distrView.widthAnchor.constraint(equalToConstant: 100),
            
            majorDropDown.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            majorDropDown.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            majorDropDown.heightAnchor.constraint(equalToConstant: 30),

            distrDropDown.leadingAnchor.constraint(equalTo: majorDropDown.trailingAnchor, constant: padding),
            distrDropDown.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            distrDropDown.heightAnchor.constraint(equalToConstant: 30),
        
            coursesView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coursesView.topAnchor.constraint(equalTo: majorDropDown.bottomAnchor, constant: padding),
            coursesView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            coursesView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding)
        ])
    }
    
    func setupDropdown() {
//        majorDropDown.dropDown.listDidDisappear {
//            self.selectedMajor = self.majorDropDown.dropDown.text!
//            self.calculateShownCourses()
//        }
        majorDropDown.dropDown.didSelect { major, _, _ in
            self.selectedMajor = major
            self.calculateShownCourses()
        }
        distrDropDown.dropDown.didSelect { distr, _, _ in
            self.selectedDistr = distr
            self.calculateShownCourses()
        }
    }
    
    func calculateShownCourses() {
        if !isFiltering && selectedMajor == "" && selectedDistr == "" {
            shownCourses = courses
        } else if isFiltering && selectedMajor == "" && selectedDistr == "" {
            shownCourses = filteredCourses
        } else {
            // check if search bar is actively filtering
            let coursesToFilterFrom = isFiltering ? filteredCourses : courses
            // filter based on distribution
            let distributionCourses = coursesToFilterFrom.filter({ course in
                if selectedDistr == "" { return true }
                let distrArray = course.distribution
                return distrArray.contains(selectedDistr)
            })
            // filter based on major
            let finalFilteredCourses = distributionCourses.filter({ course in
                return selectedMajor == "" ? true : course.number.contains(selectedMajor)
            })
            shownCourses = finalFilteredCourses
        }
        coursesView.reloadData()
    }
    
    func filterContentForSearchText(searchText: String) {
        filteredCourses = courses.filter({ course in
            course.name.lowercased().contains(searchText.lowercased()) ||
            course.number.lowercased().contains(searchText.lowercased())
        })
        calculateShownCourses()
    }
    
//    @objc func pressApply(sender: UIButton) {
//        sender.backgroundColor = .white
//        sender.setTitleColor(.darkGray, for: .normal)
//    }
//
//    @objc func releaseApply(sender: UIButton) {
//        sender.backgroundColor = .systemBlue
//        sender.setTitleColor(.white, for: .normal)
//    }
    
//    @objc func selectMajor() {
//        majorDropDown.show()
//    }
//
//    @objc func selectDistr() {
//        distrDropDown.show()
//    }
}

extension RankViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return shownCourses.count
        
//        if filteredCourses.count == 0 { return courses.count }
//        else { return filteredCourses.count }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CoursesTableViewCell.id) as? CoursesTableViewCell else { return UITableViewCell() }
        
        cell.configure(course: shownCourses[indexPath.row], index: indexPath.row)
        return cell
        
//        if filteredCourses.count == 0 {
//            cell.configure(course: courses[indexPath.row], index: indexPath.row)
//            return cell
//        } else {
//            cell.configure(course: filteredCourses[indexPath.row], index: indexPath.row)
//            return cell
//        }
    }
}

extension RankViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = courses[indexPath.item]
        let courseViewController = CourseViewController()
//        courseViewController.configure()
//        courseViewController.delegate = self
        navigationController?.pushViewController(courseViewController, animated: true)
    }
}

extension RankViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchText: searchBar.text!)
    }
}