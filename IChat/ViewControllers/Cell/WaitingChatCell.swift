//
//  WaitingChatCell.swift
//  IChat
//
//  Created by kris on 22/09/2020.
//  Copyright © 2020 kris. All rights reserved.
//

import UIKit
import SDWebImage

class WaitingChatCell: UICollectionViewCell, SelfConfigureCell{
    
    static var reuseID: String = "WaitingChatCell"
    
    var friendImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        setupConstraints()
    }
    
    func configure<U>(with value: U) where U : Hashable {
        guard let chat: Mchat = value as? Mchat else {return}
        friendImageView.sd_setImage(with: URL(string: chat.friendavatarStringURL), completed: nil)
    }
    
    private func setupConstraints() {
        
        friendImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(friendImageView)
        
        NSLayoutConstraint.activate([
            friendImageView.topAnchor.constraint(equalTo: self.topAnchor),
            friendImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            friendImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            friendImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
