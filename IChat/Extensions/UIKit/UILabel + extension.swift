//
//  UIText + extension.swift
//  IChat
//
//  Created by kris on 14/09/2020.
//  Copyright © 2020 kris. All rights reserved.
//

import UIKit

extension UILabel {
    
    convenience init(text: String, font: UIFont? = .avenir20()) {
        self.init()
        
        self.text = text
        self.font = font
    }
}
