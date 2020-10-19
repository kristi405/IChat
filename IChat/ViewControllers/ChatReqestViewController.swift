//
//  ChatReqestViewController.swift
//  IChat
//
//  Created by kris on 29/09/2020.
//  Copyright © 2020 kris. All rights reserved.
//

import UIKit
import SDWebImage

class ChatReqestViewController: UIViewController {
    
    var imageView = UIImageView(image: #imageLiteral(resourceName: "human6"), contentMode: .scaleAspectFill)
    var conteinerView = UIView()
    var nameLabel = UILabel(text: "Sara Conor", font: .laoSangamMN20())
    var aboutMeLabel = UILabel(text: "You have the opportunity to have chat with the best man in the world!", font: .systemFont(ofSize: 17) )
    var acceptButton = UIButton(title: "ACCEPT", titleColor: .whiteColor(), backgraundColor: .red)
    var denyButton = UIButton(title: "DENY", titleColor: .redColor(), backgraundColor: .white)
    
    weak var delegate: NavigationChatProtocol?
    
    private var chat: Mchat
    
    init(chat: Mchat) {
        self.chat = chat
        nameLabel.text = chat.friendUsername
        imageView.sd_setImage(with: URL(string: chat.friendavatarStringURL), completed: nil)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .whiteColor()
        costomizeElements()
        setupConstraints()
        self.acceptButton.applyGradient(cornerRadius: 10)
        
        denyButton.addTarget(self, action: #selector(denyButtonTapped), for: .touchUpInside)
        acceptButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
    }
    
    @objc private func denyButtonTapped() {
        self.dismiss(animated: true) {
            self.delegate?.removeWaitingChat(chat: self.chat)
        }
    }
    
    @objc private func acceptButtonTapped() {
        self.dismiss(animated: true) {
            self.delegate?.changeToActive(chat: self.chat)
        }
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
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        acceptButton.layer.cornerRadius = 10
        acceptButton.clipsToBounds = true
        denyButton.translatesAutoresizingMaskIntoConstraints = false
        denyButton.layer.cornerRadius = 10
        denyButton.clipsToBounds = true
        denyButton.layer.borderWidth = 1
        denyButton.layer.borderColor = CGColor(srgbRed: 1, green: 0, blue: 0, alpha: 1)
    }
}


// MARK: - Setup Constraints
    extension ChatReqestViewController {
        
        private func setupConstraints() {
            
            view.addSubview(imageView)
            view.addSubview(conteinerView)
            conteinerView.addSubview(nameLabel)
            conteinerView.addSubview(aboutMeLabel)
            conteinerView.addSubview(acceptButton)
            conteinerView.addSubview(denyButton)
            
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
                acceptButton.topAnchor.constraint(equalTo: aboutMeLabel.bottomAnchor, constant: 15),
                acceptButton.leadingAnchor.constraint(equalTo: conteinerView.leadingAnchor, constant: 35),
                acceptButton.heightAnchor.constraint(equalToConstant: 55),
                acceptButton.widthAnchor.constraint(equalToConstant: 165)
            ])
            
            NSLayoutConstraint.activate([
                denyButton.topAnchor.constraint(equalTo: aboutMeLabel.bottomAnchor, constant: 15),
                denyButton.trailingAnchor.constraint(equalTo: conteinerView.trailingAnchor, constant: -35),
                denyButton.heightAnchor.constraint(equalToConstant: 55),
                denyButton.widthAnchor.constraint(equalToConstant: 165)
            ])
        }
}
