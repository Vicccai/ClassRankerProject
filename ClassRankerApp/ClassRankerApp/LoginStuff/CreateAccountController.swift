//
//  CreateAccountController.swift
//  ClassRankerApp
//
//  Created by Mariana Meriles on 5/2/22.
//
 
import Foundation
import UIKit
 
class CreateAccountController: UIViewController {
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create Account"
        label.font = UIFont(name: "Proxima Nova Bold", size: 30)
        label.textColor = UIColor(red: 0.76, green: 0.00, blue: 0.18, alpha: 1.00)
        return label
    }()
    
    var usernameBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        return view
    }()
    
    var usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username:"
        label.font = UIFont(name: "ProximaNova-Regular", size: 14)
        label.textColor = .black
        return label
    }()
    
    var usernameField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.backgroundColor = .clear
        field.textColor = .black
        field.attributedPlaceholder = NSAttributedString(
            string: "username",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        field.font = UIFont(name: "Proxima Nova Bold", size: 14)
        return field
    }()
    
    var usernameImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Group 18")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    var passwordBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        return view
    }()
    
    var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password:"
        label.font = UIFont(name: "ProximaNova-Regular", size: 14)
        label.textColor = .black
        return label
    }()
    
    var passwordField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.backgroundColor = .clear
        field.attributedPlaceholder = NSAttributedString(
            string: "password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        field.textColor = .black
        field.font = UIFont(name: "Proxima Nova Bold", size: 14)
        field.isSecureTextEntry = true
        return field
    }()
    
    var passwordImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Group 19")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    var confirmPasswordBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        return view
    }()
    
    var confirmPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Confirm Password:"
        label.font = UIFont(name: "ProximaNova-Regular", size: 14)
        label.textColor = .black
        return label
    }()
    
    var confirmPasswordField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.backgroundColor = .clear
        field.attributedPlaceholder = NSAttributedString(
            string: "password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        field.textColor = .black
        field.font = UIFont(name: "Proxima Nova Bold", size: 14)
        field.isSecureTextEntry = true
        return field
    }()
    
    var confirmPasswordImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Group 19")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    var createAccountButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 0.76, green: 0.00, blue: 0.18, alpha: 1.00)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(createAccount), for: .touchUpInside)
        return button
    }()
    
    var createAccountLabel: UILabel = {
        let label = UILabel()
        label.text = "Create Account"
        label.font = UIFont(name: "Proxima Nova Bold", size: 14)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    var roosterImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Dance")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        view.isMultipleTouchEnabled = false
        
        for subView in [titleLabel, usernameBackView, usernameLabel, usernameField, usernameImageView, passwordBackView, passwordLabel, passwordField, passwordImageView, confirmPasswordBackView, confirmPasswordLabel, confirmPasswordField, confirmPasswordImageView, createAccountButton, createAccountLabel, roosterImageView] {
            subView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subView)
        }
        setUpConstraints()
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            
            usernameBackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIScreen.main.bounds.height*0.14),
            usernameBackView.bottomAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 10),
            usernameBackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            usernameBackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            usernameLabel.topAnchor.constraint(equalTo: usernameBackView.topAnchor, constant: 10),
            usernameLabel.leadingAnchor.constraint(equalTo: usernameImageView.trailingAnchor, constant: 20),
            
            usernameField.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor),
            usernameField.leadingAnchor.constraint(equalTo: usernameImageView.trailingAnchor, constant: 20),
            usernameField.trailingAnchor.constraint(equalTo: usernameBackView.trailingAnchor, constant: -10),
            
            usernameImageView.centerYAnchor.constraint(equalTo: usernameBackView.centerYAnchor),
            usernameImageView.heightAnchor.constraint(equalToConstant: 20),
            usernameImageView.widthAnchor.constraint(equalToConstant: 20),
            usernameImageView.leadingAnchor.constraint(equalTo: usernameBackView.leadingAnchor, constant: 20),
            
            passwordBackView.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 20),
            passwordBackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            passwordBackView.trailingAnchor.constraint(equalTo: usernameBackView.trailingAnchor),
            passwordBackView.bottomAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 10),
            
            passwordLabel.topAnchor.constraint(equalTo: passwordBackView.topAnchor, constant: 10),
            passwordLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            
            passwordField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor),
            passwordField.leadingAnchor.constraint(equalTo: passwordLabel.leadingAnchor),
            passwordField.trailingAnchor.constraint(equalTo: passwordBackView.trailingAnchor, constant: -10),
            
            passwordImageView.centerYAnchor.constraint(equalTo: passwordBackView.centerYAnchor),
            passwordImageView.heightAnchor.constraint(equalToConstant: 20),
            passwordImageView.widthAnchor.constraint(equalToConstant: 20),
            passwordImageView.leadingAnchor.constraint(equalTo: passwordBackView.leadingAnchor, constant: 20),
            
            confirmPasswordBackView.topAnchor.constraint(equalTo: passwordBackView.bottomAnchor, constant: 10),
            confirmPasswordBackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            confirmPasswordBackView.trailingAnchor.constraint(equalTo: usernameBackView.trailingAnchor),
            confirmPasswordBackView.bottomAnchor.constraint(equalTo: confirmPasswordField.bottomAnchor, constant: 10),
            
            confirmPasswordLabel.topAnchor.constraint(equalTo: confirmPasswordBackView.topAnchor, constant: 10),
            confirmPasswordLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            
            confirmPasswordField.topAnchor.constraint(equalTo: confirmPasswordLabel.bottomAnchor),
            confirmPasswordField.leadingAnchor.constraint(equalTo: confirmPasswordLabel.leadingAnchor),
            confirmPasswordField.trailingAnchor.constraint(equalTo: confirmPasswordBackView.trailingAnchor, constant: -10),
            
            confirmPasswordImageView.centerYAnchor.constraint(equalTo: confirmPasswordBackView.centerYAnchor),
            confirmPasswordImageView.heightAnchor.constraint(equalToConstant: 20),
            confirmPasswordImageView.widthAnchor.constraint(equalToConstant: 20),
            confirmPasswordImageView.leadingAnchor.constraint(equalTo: confirmPasswordBackView.leadingAnchor, constant: 20),
            
            createAccountButton.topAnchor.constraint(equalTo: confirmPasswordBackView.bottomAnchor, constant: 15),
            createAccountButton.heightAnchor.constraint(equalToConstant: 40),
            createAccountButton.widthAnchor.constraint(equalToConstant: 150),
            createAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            createAccountLabel.centerYAnchor.constraint(equalTo: createAccountButton.centerYAnchor),
            createAccountLabel.centerXAnchor.constraint(equalTo: createAccountButton.centerXAnchor),
            
            roosterImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 20),
            roosterImageView.heightAnchor.constraint(equalToConstant: 250),
            roosterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -40),
            roosterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    @objc func login() {
        navigationController?.pushViewController(LoginController(), animated: true)
    }
    
    @objc func createAccount() {
        if usernameField.text == "" {
            let alert = UIAlertController(title: "Invalid", message: nil, preferredStyle: .alert)
            alert.view.tintColor = .darkGray
            alert.addAction(UIAlertAction(title: "Input Username", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        else if passwordField.text == "" {
            let alert = UIAlertController(title: "Invalid", message: nil, preferredStyle: .alert)
            alert.view.tintColor = .darkGray
            alert.addAction(UIAlertAction(title: "Input Password", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        else if confirmPasswordField.text == "" {
            let alert = UIAlertController(title: "Invalid", message: nil, preferredStyle: .alert)
            alert.view.tintColor = .darkGray
            alert.addAction(UIAlertAction(title: "Confirm Password", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        else if passwordField.text != confirmPasswordField.text {
            let alert = UIAlertController(title: "Invalid: Passwords Do Not Match", message: nil, preferredStyle: .alert)
            alert.view.tintColor = .darkGray
            alert.addAction(UIAlertAction(title: "Confirm Password", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        

        NetworkManager.registerAccount(username: usernameField.text!, password: passwordField.text!) { user in
            NetworkManager.login(username: self.usernameField.text!, password: self.passwordField.text!) { user in
                Globals.user = User(username: user.username, session_token: user.session_token)
                self.navigationController?.pushViewController(RankViewController(), animated: true)
            } failureCompletion: {
                let alert = UIAlertController(title: "Invalid Username or Password", message: nil, preferredStyle: .alert)
                alert.view.tintColor = .darkGray
                alert.addAction(UIAlertAction(title: "Try again", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            /*self.navigationController?.pushViewController(loginViewController, animated: true)*/
        } failureCompletion: {
            let alert = UIAlertController(title: "Account already exists", message: nil, preferredStyle: .alert)
            alert.view.tintColor = .darkGray
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
