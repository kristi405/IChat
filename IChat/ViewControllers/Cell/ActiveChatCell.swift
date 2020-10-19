//
//  ActiveChatCell.swift
//  IChat
//
//  Created by kris on 21/09/2020.
//  Copyright © 2020 kris. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class ActiveChatCell: UICollectionViewCell, SelfConfigureCell {

    static var reuseID: String = "ActiveChatCell"
    
    var friendImageView = UIImageView()
    var friendName = UILabel(text: "User name", font: .laoSangamMN20())
    var lastMessage = UILabel(text: "How are you", font: .laoSangamMN18())
    var gradientView = GradientView(from: .topTrailing, to: .bottomLeading, startColor: #colorLiteral(red: 0.8941176471, green: 0.6431372549, blue: 0.937254902, alpha: 1), endColor: #colorLiteral(red: 0.4392156863, green: 0.7568627451, blue: 0.937254902, alpha: 1))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        backgroundColor = .whiteColor()
        
        self.layer.cornerRadius = 6
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure<U>(with value: U) where U : Hashable {
        guard let chat: Mchat = value as? Mchat else {return}
        friendName.text = chat.friendUsername
        lastMessage.text = chat.lastMessage
        friendImageView.sd_setImage(with: URL(string: chat.friendavatarStringURL), completed: nil)
    }
            
    private func setupConstraints() {
        
        friendImageView.translatesAutoresizingMaskIntoConstraints = false
        friendName.translatesAutoresizingMaskIntoConstraints = false
        lastMessage.translatesAutoresizingMaskIntoConstraints = false
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        
        friendImageView.backgroundColor = .orange
        gradientView.backgroundColor = .black
        
        addSubview(friendImageView)
        addSubview(friendName)
        addSubview(lastMessage)
        addSubview(gradientView)
        
        NSLayoutConstraint.activate([
            friendImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            friendImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            friendImageView.heightAnchor.constraint(equalToConstant: 78),
            friendImageView.widthAnchor.constraint(equalToConstant: 78)
        ])
        
        NSLayoutConstraint.activate([
            friendName.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            friendName.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 20),
            friendName.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            lastMessage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            lastMessage.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 20),
            lastMessage.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            gradientView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            gradientView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 78),
            gradientView.widthAnchor.constraint(equalToConstant: 8)
        ])
    }
}
