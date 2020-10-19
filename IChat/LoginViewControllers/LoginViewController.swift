//
//  LoginViewController.swift
//  IChat
//
//  Created by kris on 16/09/2020.
//  Copyright © 2020 kris. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {
    
    let helloLabel = UILabel(text: "Welcom back!", font: .avenir26())

    let loginWithLabel = UILabel(text: "Login with")
    let orLabel = UILabel(text: "Or")
    let emailLabel = UILabel(text: "Email")
    let passwordLabel = UILabel(text: "Password")
    
    let neadAnAccountLabel = UILabel(text: "Nead an account")
    
    let googleButton = UIButton(title: "Google", titleColor: .blackColor(), backgraundColor: .white, isShadow: true)
    let loginButton = UIButton(title: "Login", titleColor: .whiteColor(), backgraundColor: .black)
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign up", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.tintColor = .redColor()
        return button
    }()
    
    var delegate: AuthNavigationDeligate?
    
    let emailTextField = OneLineTextFild(font: .avenir20())
    let passwordTextField = OneLineTextFild(font: .avenir20())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupConstraints()
        googleButton.setGoggleImage()
        
        loginButton.addTarget(self, action: #selector(loginButtonTouch), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonTouch), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(googleButtonTouch), for: .touchUpInside)
    }
    
    @objc private func loginButtonTouch() {
        
        AuthService.shered.login(email: emailTextField.text, password: passwordTextField.text) { (result) in
            switch result {
            case .success(let user):
                self.showAlert(title: "Успешно!", massage: "Вы авторизованы!") {
                    UserService.shered.getData(user: user) { (result) in
                        switch result {
                        case .success(let muser):
                            let mainTabBar = MainTabBarVewController(currentUser: muser)
                            mainTabBar.modalPresentationStyle = .fullScreen
                            self.present(mainTabBar, animated: true, completion: nil)
                        case .failure(_):
                            self.present(SetupProfilViewController(currentUser: user), animated: true, completion: nil)
                        }
                    }
                }
            case .failure(let error):
                self.showAlert(title: "Ошибка", massage: error.localizedDescription)
            }
        }
    }
    
    @objc private func signUpButtonTouch() {
        self.dismiss(animated: true) {
            self.delegate?.toSignUp()
        }
    }
    
    @objc private func googleButtonTouch() {
           GIDSignIn.sharedInstance()?.presentingViewController = self
           GIDSignIn.sharedInstance().signIn()
       }
}


// MARK: - Setup Constraints
extension LoginViewController {
    
    private func setupConstraints() {
        
        let googleView = ButtonFormView(label: loginWithLabel, button: googleButton)
        let emailStackView = UIStackView(arrangedSubviews: [emailLabel, emailTextField], axis: .vertical, spacing: 0)
        let passwordStackView = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField], axis: .vertical, spacing: 0)
        loginButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [googleView, orLabel, emailStackView, passwordStackView, loginButton], axis: .vertical, spacing: 40)
        
        let signUpStackView = UIStackView(arrangedSubviews: [neadAnAccountLabel, signUpButton], axis: .horizontal, spacing: -1)
        
        helloLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        signUpStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(helloLabel)
        view.addSubview(stackView)
        view.addSubview(signUpStackView)
        
        NSLayoutConstraint.activate([
            helloLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            helloLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: helloLabel.bottomAnchor, constant: 60),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        NSLayoutConstraint.activate([
            signUpStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 50),
            signUpStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            signUpStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
}
