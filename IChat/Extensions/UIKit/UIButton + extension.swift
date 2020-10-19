//
//  UIButton + extension.swift
//  IChat
//
//  Created by kris on 14/09/2020.
//  Copyright © 2020 kris. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    convenience init (title: String,
                      titleColor: UIColor,
                      backgraundColor: UIColor,
                      font: UIFont? = .avenir20(),
                      isShadow: Bool = false,
                      cornerRadius: CGFloat = 4) {
        self.init(type: .system)
        
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgraundColor
        self.titleLabel?.font = font
        self.layer.cornerRadius = cornerRadius
        
        if isShadow {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowRadius = 4
            self.layer.shadowOpacity = 0.2
            self.layer.shadowOffset = CGSize(width: 0, height: 4)
        }
    }
    
    func setGoggleImage() {
        let googleImage = UIImageView()
        googleImage.image = #imageLiteral(resourceName: "googleLogo")
        googleImage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(googleImage)
        NSLayoutConstraint.activate([
            googleImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            googleImage.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
