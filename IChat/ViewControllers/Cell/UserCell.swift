//
//  UserCell.swift
//  IChat
//
//  Created by kris on 23/09/2020.
//  Copyright © 2020 kris. All rights reserved.
//

import UIKit
import SDWebImage

class UserCell: UICollectionViewCell, SelfConfigureCell {
    
    static var reuseID: String = "UserCell"
    
    var userImage = UIImageView()
    var userName = UILabel(text: "text", font: .laoSangamMN20())
    var conteinerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        setupConstraints()
        
        conteinerView.layer.cornerRadius = 4
        conteinerView.clipsToBounds = true
        conteinerView.layer.shadowColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        conteinerView.layer.shadowRadius = 7
        conteinerView.layer.shadowOpacity = 0.5
        conteinerView.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    private func setupConstraints() {
        userImage.translatesAutoresizingMaskIntoConstraints = false
        userName.translatesAutoresizingMaskIntoConstraints = false
        conteinerView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(conteinerView)
        conteinerView.addSubview(userImage)
        conteinerView.addSubview(userName)
        
        NSLayoutConstraint.activate([
            conteinerView.topAnchor.constraint(equalTo: self.topAnchor),
            conteinerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            conteinerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            conteinerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            userImage.topAnchor.constraint(equalTo: conteinerView.topAnchor),
            userImage.leadingAnchor.constraint(equalTo: conteinerView.leadingAnchor),
            userImage.trailingAnchor.constraint(equalTo: conteinerView.trailingAnchor),
            userImage.heightAnchor.constraint(equalTo: conteinerView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            userName.topAnchor.constraint(equalTo: userImage.bottomAnchor),
            userName.leadingAnchor.constraint(equalTo: conteinerView.leadingAnchor),
            userName.trailingAnchor.constraint(equalTo: conteinerView.trailingAnchor),
            userName.bottomAnchor.constraint(equalTo: conteinerView.bottomAnchor)
        ])
    }
    
    override func prepareForReuse() {
        userImage.image = nil
    }
    
    func configure<U>(with value: U) where U : Hashable {
        guard let user: MUser = value as? MUser else {return}
        userName.text = user.username
        guard let url = URL(string: user.avatarStringURL) else {return}
        userImage.sd_setImage(with: url, completed: nil)
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
