//
//  ViewController.swift
//  IChat
//
//  Created by kris on 14/09/2020.
//  Copyright © 2020 kris. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn

class ViewController: UIViewController {
    
    let logoImage = UIImageView(image: #imageLiteral(resourceName: "Logo"), contentMode: .scaleAspectFit)
    
    let googleLabel = UILabel(text: "Get started with")
    let emailLabel = UILabel(text: "Or sign up with")
    let alreadyOnboardLabel = UILabel(text: "Already On board")
    
    let emailButton = UIButton(title: "Email", titleColor: .whiteColor(), backgraundColor: .black)
    let googleButton = UIButton(title: "Google", titleColor: .blackColor(), backgraundColor: .white, isShadow: true)
    let loginButton = UIButton(title: "Login", titleColor: .redColor(), backgraundColor: .white, isShadow: true)
    
    let signUpVC = SignUpViewController()
    let loginVC = LoginViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        googleButton.setGoggleImage()
        setupConstraints()
        
        emailButton.addTarget(self, action: #selector(emailButtonTouch), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTouch), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(googleButtonTouch), for: .touchUpInside)
        
        signUpVC.delegate = self
        loginVC.delegate = self
        
        GIDSignIn.sharedInstance()?.delegate = self
    }

    @objc private func emailButtonTouch() {
        present(signUpVC, animated: true, completion: nil)
    }
    
    @objc private func loginButtonTouch() {
        present(loginVC, animated: true, completion: nil)
    }
    
    @objc private func googleButtonTouch() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
}


// MARK: - GIDSignInDelegate
extension ViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        AuthService.shered.googleLogIn(user: user, error: error) { (result) in
            switch result {
            case .success(let user):
                UserService.shered.getData(user: user) { (result) in
                    switch result {
                    case .success(let muser):
                        UIApplication.topViewController()?.showAlert(title: "Успешно", massage: "Вы авторизованы") {
                            let mainTabBar = MainTabBarVewController(currentUser: muser)
                            mainTabBar.modalPresentationStyle = .fullScreen
                            UIApplication.topViewController()?.present(mainTabBar, animated: true, completion: nil)
                        }
                    case .failure(_):
                        UIApplication.topViewController()?.showAlert(title: "Успешно", massage: "Вы зарегистрированы") {
                            UIApplication.topViewController()?.present(SetupProfilViewController(currentUser: user), animated: true, completion: nil)
                        }
                    }
                }
            case .failure(let error):
                self.showAlert(title: "Ошибка", massage: error.localizedDescription)
            }
        }
    }
}

// MARK: - NavigationDeligate
extension ViewController: AuthNavigationDeligate {
    func toLogin() {
        present(loginVC, animated: true, completion: nil)
    }
    
    func toSignUp() {
        present(signUpVC, animated: true, completion: nil)
    }
}

// MARK: - setupConstraints
extension ViewController {
    
    private func setupConstraints() {
        
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        
        let googleView = ButtonFormView(label: googleLabel, button: googleButton)
        let emailView = ButtonFormView(label: emailLabel, button: emailButton)
        let loginView = ButtonFormView(label: alreadyOnboardLabel, button: loginButton)
        
        let stackView = UIStackView(arrangedSubviews: [googleView, emailView, loginView], axis: .vertical, spacing: 45)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoImage)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            logoImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 160),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
}

// MARK: - SwiftUI

import SwiftUI

struct ViewControllerProvider: PreviewProvider {
    
    static var previews: some View {
        ContenerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContenerView: UIViewControllerRepresentable {

        var viewController = ViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<ViewControllerProvider.ContenerView>) -> ViewController {
            viewController
        }
        
        func updateUIViewController(_ uiViewController: ViewControllerProvider.ContenerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ViewControllerProvider.ContenerView>) {
        
        }
    }
}

