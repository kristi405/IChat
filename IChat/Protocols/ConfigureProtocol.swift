//
//  ConfigureProtocol.swift
//  IChat
//
//  Created by kris on 23/09/2020.
//  Copyright © 2020 kris. All rights reserved.
//

import UIKit

protocol SelfConfigureCell {
    
    static var reuseID: String {get}
    func configure<U: Hashable>(with value: U)
}
