//
//  SignUpViewController.swift
//  IChat
//
//  Created by kris on 15/09/2020.
//  Copyright © 2020 kris. All rights reserved.
//

import Foundation
import UIKit

class SignUpViewController: UIViewController {
    
    let welcomLabel = UILabel(text: "Glad to see you", font: .avenir26())
    
    let emailLabel = UILabel(text: "Email")
    let passwordLabel = UILabel(text: "Password")
    let confirmPasswordLabel = UILabel(text: "Confirm password")
    
    let alreadyOnboardLabel = UILabel(text: "Already onboard")
    
    let emailTextField = OneLineTextFild(font: .avenir20())
    let passwordTextField = OneLineTextFild(font: .avenir20())
    let confirmPasswordTextField = OneLineTextFild(font: .avenir20())
    
    let signUpButton = UIButton(title: "Sign Up", titleColor: .white, backgraundColor: .black)
    let loginButton = UIButton()
    
    var delegate: AuthNavigationDeligate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.redColor(), for: .normal)
        setupConstraints()
        
        signUpButton.addTarget(self, action: #selector(signUpButtonTouch), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTouch), for: .touchUpInside)
    }
    
    @objc private func signUpButtonTouch() {

        AuthService.shered.register(email: emailTextField.text, password: passwordTextField.text, confirmPassword: confirmPasswordTextField.text) { (result) in
            switch result {
            case .success(let user):
                self.showAlert(title: "Успешно", massage: "Вы зарегистрированы") {
                    self.present(SetupProfilViewController(currentUser: user), animated: true, completion: nil)
                }
            case .failure(let error):
                self.showAlert(title: "Ошибка", massage: error.localizedDescription)
            }
        }
    }
    
    @objc private func loginButtonTouch() {
        self.dismiss(animated: true) {
            self.delegate?.toLogin()
        }
    }
}


// MARK: - setupConstraints
extension SignUpViewController {
    
    private func setupConstraints() {
        
        let emailStackView = UIStackView(arrangedSubviews: [emailLabel, emailTextField], axis: .vertical, spacing: 10)
        let passwordStackView = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField], axis: .vertical, spacing: 10)
        let confirmPasswordStackView = UIStackView(arrangedSubviews: [confirmPasswordLabel, confirmPasswordTextField], axis: .vertical, spacing: 10)
        
        signUpButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [emailStackView, passwordStackView, confirmPasswordStackView, signUpButton], axis: .vertical, spacing: 40)
        
        let buttonStackView = UIStackView(arrangedSubviews: [alreadyOnboardLabel, loginButton], axis: .horizontal, spacing: -1)
        
        welcomLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(welcomLabel)
        view.addSubview(stackView)
        view.addSubview(buttonStackView)
        
        NSLayoutConstraint.activate([
            welcomLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            welcomLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: welcomLabel.bottomAnchor, constant: 80),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 90),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
    }
}
