//
//  ClassCell.swift
//  ClassRankerApp
//
//  Created by Victor Cai on 4/28/22.
//

import UIKit

class CourseCell: UICollectionViewCell {
    
    static let id = "CourseCellId"
    
    let cellPadding: CGFloat = 20
    
//    var rankingLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .black
//        label.font = .systemFont(ofSize: 30)
//        return label
//    }()
    
    var numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 40)
        label.textAlignment = .right
        return label
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 25)
        label.textAlignment = .right
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    var ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 30)
        return label
    }()
    
    var favButton: UIButton = {
        let button = UIButton()
        // will be changed to a star image with button.setImage()
        button.setTitle("X", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    var favNumber: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 40
        for subView in [numberLabel, nameLabel, ratingLabel, favButton, favNumber] {
            subView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(subView)
        }
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            ratingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: cellPadding),
            ratingLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            favButton.topAnchor.constraint(equalTo: contentView.centerYAnchor),
            favButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: cellPadding),
            favButton.trailingAnchor.constraint(equalTo: ratingLabel.trailingAnchor),
            favButton.heightAnchor.constraint(equalToConstant: 30),
            
            favNumber.topAnchor.constraint(equalTo: favButton.bottomAnchor),
            favNumber.centerXAnchor.constraint(equalTo: favButton.centerXAnchor),
            
            numberLabel.leadingAnchor.constraint(equalTo: ratingLabel.trailingAnchor, constant: cellPadding),
            numberLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -cellPadding),
            numberLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: ratingLabel.trailingAnchor, constant: cellPadding),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -cellPadding),
            nameLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 10),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -cellPadding)
        ])
    }
    
    func configure(course: Course, index: Int) {
        numberLabel.text = course.number
        nameLabel.text = course.name
        ratingLabel.text = String(course.rating)
        favNumber.text = String(course.favNumber)
//        rankingLabel.text = String(index) + "."
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
