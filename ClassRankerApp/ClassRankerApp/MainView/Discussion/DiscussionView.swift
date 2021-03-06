//
//  DiscussionView.swift
//  ClassRankerApp
//
//  Created by Mariana Meriles on 5/6/22.
//
 
import Foundation
import UIKit
import IQKeyboardManagerSwift
 
class DiscussionView: UIStackView {
    
    var collapsed = true
    var course: Course?
    var descriptionController: DescriptionViewController?
    var originalHeight: CGFloat = 0
    
    // ui view for discussion title view
    lazy var disTitleView: UIView = {
        var disLabel: UILabel = {
            let label = UILabel()
            label.text = "Discussions"
            label.textColor = .black
            label.font = UIFont(name: "Proxima Nova Bold", size: 30)
            return label
        }()
        
        var commentNumBackView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor(red: 1.00, green: 0.44, blue: 0.57, alpha: 1.00)
            view.clipsToBounds = true
            view.layer.cornerRadius = 17.5
            return view
        }()
        
        var expandButton: UIButton = {
            let button = UIButton()
            button.addTarget(self, action: #selector(expandDiscussion), for: .touchUpInside)
            return button
        }()
 
        let view = UIView()
//        view.layer.borderColor = UIColor.black.cgColor
//        view.layer.borderWidth = 1
        view.backgroundColor = .white
        
        for subView in [disLabel, commentNumBackView, commentsNumber, expandLeft, expandRight, expandButton] {
            subView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subView)
        }
        
        NSLayoutConstraint.activate([
            disLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            disLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
 
            commentNumBackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 7.5),
            commentNumBackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -7.5),
            commentNumBackView.leadingAnchor.constraint(equalTo: disLabel.trailingAnchor, constant: 20),
            commentNumBackView.trailingAnchor.constraint(equalTo: commentsNumber.trailingAnchor, constant: 15),
 
            commentsNumber.centerYAnchor.constraint(equalTo: commentNumBackView.centerYAnchor),
            commentsNumber.leadingAnchor.constraint(equalTo: commentNumBackView.leadingAnchor, constant: 15),
 
            expandRight.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -1),
            expandRight.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            expandRight.widthAnchor.constraint(equalToConstant: 10),
            expandRight.heightAnchor.constraint(equalToConstant: 10),
 
            expandLeft.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 1),
            expandLeft.trailingAnchor.constraint(equalTo: expandRight.leadingAnchor, constant: -2.7),
            expandLeft.widthAnchor.constraint(equalToConstant: 10),
            expandLeft.heightAnchor.constraint(equalToConstant: 10),
            
            expandButton.topAnchor.constraint(equalTo: view.topAnchor),
            expandButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            expandButton.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            expandButton.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        return view
    }()
    
    var expandLeft: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Vector")
        return image
    }()
    
    var expandRight: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Vector (1)")
        return image
    }()
    
    var commentsNumber: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Proxima Nova Bold", size: 30)
        return label
    }()
    
    // uitable subview for comments (gets hidden)
    lazy var commentsView: UITableView = {
        let tableView = UITableView()
        tableView.register(CommentViewCell.self, forCellReuseIdentifier: CommentViewCell.id)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    
    // ui subview for commenting (gets hidden)
    lazy var yourCommentView: UIView = {
        var commentFieldBackView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
            return view
        }()
        
        var commentButton: UIButton = {
            let button = UIButton()
            button.addTarget(self, action: #selector(postComment), for: .touchUpInside)
            button.backgroundColor = UIColor(red: 0.76, green: 0.00, blue: 0.18, alpha: 1.00)
            button.layer.cornerRadius = 8
            return button
        }()
        
        var sendLabel: UILabel = {
            let label = UILabel()
            label.text = "Send"
            label.textColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
            label.font = UIFont(name: "ProximaNova-Regular", size: 17.5)
            return label
        }()
        
        let view = UIView()
        view.backgroundColor = .white
//        view.layer.borderColor = UIColor.black.cgColor
//        view.layer.borderWidth = 1
        for subView in [commentFieldBackView, commentField, commentButton, sendLabel] {
            subView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subView)
        }
        NSLayoutConstraint.activate([
            commentFieldBackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            commentFieldBackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15),
            commentFieldBackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            commentFieldBackView.heightAnchor.constraint(equalToConstant: 40),
            commentFieldBackView.trailingAnchor.constraint(equalTo: commentButton.leadingAnchor, constant: -10),
            
            commentField.centerYAnchor.constraint(equalTo: commentFieldBackView.centerYAnchor),
            commentField.leadingAnchor.constraint(equalTo: commentFieldBackView.leadingAnchor, constant: 10),
            commentField.trailingAnchor.constraint(equalTo: commentFieldBackView.trailingAnchor, constant: -10),
            
            commentButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            commentButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            commentButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            commentButton.widthAnchor.constraint(equalToConstant: 60),
            
            sendLabel.centerXAnchor.constraint(equalTo: commentButton.centerXAnchor),
            sendLabel.centerYAnchor.constraint(equalTo: commentButton.centerYAnchor)
        ])
        return view
    }()
    
    var commentField: UITextField = {
        let field = UITextField()
        field.font = UIFont(name: "ProximaNova-Regular", size: 17.5)
        field.attributedPlaceholder = NSAttributedString(
            string: "Add a comment",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        field.autocapitalizationType = .none
        field.addTarget(self, action: #selector(shrinkView), for: .editingDidBegin)
        field.addTarget(self, action: #selector(expandView), for: .editingDidEnd)
        field.becomeFirstResponder()
        field.textColor = .black
        field.enablesReturnKeyAutomatically = false
        return field
    }()
    
    @objc func shrinkView() {
        originalHeight = yourCommentView.frame.origin.y
        yourCommentView.frame.origin.y = Globals.keyboardHeight
    }

    @objc func expandView() {
        yourCommentView.frame.origin.y = originalHeight
    }
//    var comments = [Comment(id: 12, username: "mariana", description: "yo check out this little star thing"), Comment(id: 15, username: "victor", description: "haha cool so anyway i built this drop down menu entirely from scratch or whatever")]
    
    // comments data
    var comments : [Comment] = []
    
    // adding subviews
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        commentsNumber.text = String(comments.count)
        commentsView.isHidden = true
        yourCommentView.isHidden = true
        for subView in [disTitleView, commentsView, yourCommentView] {
            subView.translatesAutoresizingMaskIntoConstraints = false
            addArrangedSubview(subView)
        }
        setUpConstraints()
    }
        
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            disTitleView.topAnchor.constraint(equalTo: topAnchor),
            disTitleView.leadingAnchor.constraint(equalTo: leadingAnchor),
            disTitleView.trailingAnchor.constraint(equalTo: trailingAnchor),
            disTitleView.heightAnchor.constraint(equalToConstant: 50),
            
            commentsView.topAnchor.constraint(equalTo: disTitleView.bottomAnchor),
            commentsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            commentsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            commentsView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/1.4),
            
            yourCommentView.topAnchor.constraint(equalTo: commentsView.bottomAnchor),
            yourCommentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            yourCommentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            yourCommentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc func expandDiscussion() {
        if collapsed == true {
            expandRight.image = UIImage(named: "Vector")
            expandLeft.image = UIImage(named: "Vector (1)")
            UIView.animate(
                withDuration: 0.1,
                delay: 0.0,
                options: [.transitionFlipFromTop],
                animations: {
                    self.commentsView.isHidden = false
                    self.yourCommentView.isHidden = false
            })
            collapsed = false
        } else {
            expandLeft.image = UIImage(named: "Vector")
            expandRight.image = UIImage(named: "Vector (1)")
            UIView.animate(
                withDuration: 0.1,
                delay: 0.0,
                options: [.transitionFlipFromBottom],
                animations: {
                    self.commentsView.isHidden = true
                    self.yourCommentView.isHidden = true
            })
            self.endEditing(true)
            collapsed = true
        }
    }
    
    @objc func postComment() {
        if commentField.text != ""{
            if Globals.guest.boolValue == true {
                self.endEditing(true)
                let alert = UIAlertController(title: "Please Login", message: nil, preferredStyle: .alert)
                alert.view.tintColor = .darkGray
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                self.endEditing(true)
            }
            else{
                NetworkManager.postCommentByUser(course: course!, user: Globals.user, description: commentField.text!) { comment in
                    self.comments.append(comment)
                    self.commentsView.reloadData()
                    self.commentField.text = ""
                    self.commentsNumber.text = String(self.comments.count)
                }
            }
        }
    }
    
    func deleteComment(comment: Comment) {
        if Globals.guest.boolValue == true {
            return
        }
        NetworkManager.deleteComment(comment: comment, user: Globals.user) { commentToDelete in
//            let commentIndex = self.comments.first(where: { comment in
//                commentToDelete == comment
//            })
            if let index = self.comments.firstIndex(of: commentToDelete) {
                self.comments.remove(at: index)
                self.commentsNumber.text = String(self.comments.count)
            }
            self.commentsView.reloadData()
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
 
extension DiscussionView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentViewCell.id) as? CommentViewCell else { return UITableViewCell() }
        cell.configure(comment: comments[indexPath.row])
        cell.delegate = self
        return cell
    }
}
 
extension DiscussionView: UITableViewDelegate {
}
