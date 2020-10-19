//
//  SetupProfilViewController.swift
//  IChat
//
//  Created by kris on 16/09/2020.
//  Copyright © 2020 kris. All rights reserved.
//

import UIKit
import FirebaseAuth
import SDWebImage

class SetupProfilViewController: UIViewController {
        
    let fillImageView = AddFotoView()
    
    let welcomLabel = UILabel(text: "Setup Profile", font: .avenir26())
    
    let fullNameLabel = UILabel(text: "Full name")
    let aboutMeLabel = UILabel(text: "About me")
    let sexLabel = UILabel(text: "Sex")
    let goToChatsButton = UIButton(title: "Go to chats!", titleColor: .white, backgraundColor: .blackColor())
    
    let fullNameTextField = OneLineTextFild(font: .avenir20())
    let aboutMeTextField = OneLineTextFild(font: .avenir20())
    
    let sexSegmentedControl = UISegmentedControl(first: "Male", second: "Female")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupConstraints()
        goToChatsButton.addTarget(self, action: #selector(goToChatsButtonTouch), for: .touchUpInside)
        fillImageView.plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
    }
    
    @objc private func plusButtonTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    private let currentUser: User
    
    init(currentUser: User) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        
        let username = currentUser.displayName
        fullNameTextField.text = username
        if let photoURL = currentUser.photoURL {
            fillImageView.circleImageView.sd_setImage(with: photoURL, completed: nil)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func goToChatsButtonTouch() {
        
        UserService.shered.saveData(id: currentUser.uid,
                                    email: currentUser.email!,
                                    username: fullNameTextField.text,
                                    avatarImage: fillImageView.circleImageView.image,
                                    description: aboutMeTextField.text,
                                    sex: sexSegmentedControl.titleForSegment(at: sexSegmentedControl.selectedSegmentIndex)) { (result) in
                                        switch result {
                                        case .success(let muser):
                                            self.showAlert(title: "Успешно", massage: "Приятного общения", complation: {
                                                let mainTabBar = MainTabBarVewController(currentUser: muser)
                                                mainTabBar.modalPresentationStyle = .fullScreen
                                                self.present(mainTabBar, animated: true, completion: nil)
                                            })
                                        case .failure(let error):
                                            self.showAlert(title: "Ошибка", massage: error.localizedDescription)
                                        }
        }
    }
}


// MARK: - UIImagePickerControllerDelegate
extension SetupProfilViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
        fillImageView.circleImageView.image = image
    }
}

// MARK: - Setup Constraints
extension SetupProfilViewController {
    
    private func setupConstraints() {
       
        let fullNameStackView = UIStackView(arrangedSubviews: [fullNameLabel, fullNameTextField], axis: .vertical, spacing: 35)
        let aboutMeStackView = UIStackView(arrangedSubviews: [aboutMeLabel, aboutMeTextField], axis: .vertical, spacing: 35)
        let sexStackView = UIStackView(arrangedSubviews: [sexLabel, sexSegmentedControl], axis: .vertical, spacing: 20)
        
        goToChatsButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [fullNameStackView, aboutMeStackView, sexStackView, goToChatsButton], axis: .vertical, spacing: 30)
        
        fillImageView.translatesAutoresizingMaskIntoConstraints = false
        welcomLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(welcomLabel)
        view.addSubview(stackView)
        view.addSubview(fillImageView)
        
        NSLayoutConstraint.activate([
            welcomLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100)
        ])
        
        NSLayoutConstraint.activate([
            fillImageView.topAnchor.constraint(equalTo: welcomLabel.bottomAnchor, constant: 60),
            fillImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: fillImageView.bottomAnchor, constant: 60),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
}
