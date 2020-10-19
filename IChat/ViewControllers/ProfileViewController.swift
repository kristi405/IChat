//
//  ProfileViewController.swift
//  IChat
//
//  Created by kris on 25/09/2020.
//  Copyright © 2020 kris. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {
    
    var imageView = UIImageView(image: #imageLiteral(resourceName: "human6"), contentMode: .scaleAspectFill)
    var conteinerView = UIView()
    var nameLabel = UILabel(text: "Sara Conor", font: .laoSangamMN20())
    var aboutMeLabel = UILabel(text: "You have the opportunity to have chat with the best man in the world!")
    var textField = InsertableTextField()
    
    private var user: MUser
    
    init(user: MUser) {
        self.user = user
        self.nameLabel.text = user.username
        self.aboutMeLabel.text = user.description
        self.imageView.sd_setImage(with: URL(string: user.avatarStringURL), completed: nil)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        costomizeElements()
        setupConstraints()
    }
    
    private func costomizeElements() {
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        conteinerView.translatesAutoresizingMaskIntoConstraints = false
        conteinerView.layer.cornerRadius = 30
        conteinerView.backgroundColor = .whiteColor()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutMeLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutMeLabel.numberOfLines = 0
        aboutMeLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .taxtFieldColor()
        
        if let button = textField.rightView as? UIButton {
            button.addTarget(self, action: #selector(sentMassege), for: .touchUpInside)
        }
    }
    
    @objc private func sentMassege() {
        guard let massage = textField.text, massage != "" else {return}
        self.dismiss(animated: true) {
            UserService.shered.createWatingChats(message: massage, reciaver: self.user) { (result) in
                switch result {
                case .success:
                    UIApplication.topViewController()?.showAlert(title: "Успешно", massage: "Ваше сообщение для \(self.user.username) отправлено")
                case .failure(let error):
                    UIApplication.topViewController()?.showAlert(title: "Ошибка", massage: error.localizedDescription)
                }
            }
        }
    }
}


// MARK: - Setup Constraints
extension ProfileViewController {
    
    private func setupConstraints() {
        
        view.addSubview(imageView)
        view.addSubview(conteinerView)
        conteinerView.addSubview(nameLabel)
        conteinerView.addSubview(aboutMeLabel)
        conteinerView.addSubview(textField)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: conteinerView.topAnchor, constant: 30)
        ])
        
        NSLayoutConstraint.activate([
            conteinerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            conteinerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            conteinerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            conteinerView.heightAnchor.constraint(equalToConstant: 206)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: conteinerView.topAnchor, constant: 15),
            nameLabel.leadingAnchor.constraint(equalTo: conteinerView.leadingAnchor, constant: 35),
            nameLabel.trailingAnchor.constraint(equalTo: conteinerView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            aboutMeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            aboutMeLabel.leadingAnchor.constraint(equalTo: conteinerView.leadingAnchor, constant: 35),
            aboutMeLabel.trailingAnchor.constraint(equalTo: conteinerView.trailingAnchor, constant: -35)
        ])
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: aboutMeLabel.bottomAnchor, constant: 10),
            textField.leadingAnchor.constraint(equalTo: conteinerView.leadingAnchor, constant: 35),
            textField.trailingAnchor.constraint(equalTo: conteinerView.trailingAnchor, constant: -35),
            textField.heightAnchor.constraint(equalToConstant: 42)
        ])
    }
}
