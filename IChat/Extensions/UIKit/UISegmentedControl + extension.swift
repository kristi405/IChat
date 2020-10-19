//
//  UISegmentedControl + extension.swift
//  IChat
//
//  Created by kris on 17/09/2020.
//  Copyright © 2020 kris. All rights reserved.
//

import UIKit

extension UISegmentedControl {
    
    convenience init(first: String, second: String) {
        self.init()
        
        self.insertSegment(withTitle: first, at: 0, animated: true)
        self.insertSegment(withTitle: second, at: 0, animated: true)
        selectedSegmentIndex = 0
    }
}
