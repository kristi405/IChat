//
//  OneLineTextFild.swift
//  IChat
//
//  Created by kris on 15/09/2020.
//  Copyright © 2020 kris. All rights reserved.
//

import UIKit

class OneLineTextFild: UITextField {
    convenience init(font: UIFont? = .avenir20()) {
        self.init()
        
        self.font = font
        self.borderStyle = .none
        self.translatesAutoresizingMaskIntoConstraints = false
        
        var bottonView = UIView()
        bottonView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        bottonView.translatesAutoresizingMaskIntoConstraints = false
        bottonView.backgroundColor = .taxtFieldColor()
        
        self.addSubview(bottonView)
        
        NSLayoutConstraint.activate([
            bottonView.topAnchor.constraint(equalTo: self.topAnchor),
            bottonView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bottonView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bottonView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
