//
//  SectionHeder.swift
//  IChat
//
//  Created by kris on 22/09/2020.
//  Copyright © 2020 kris. All rights reserved.
//

import UIKit

class SectionHeder: UICollectionReusableView {
    
    static var reuseID: String = "SectionHeder"
    
    var title = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(title)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: self.topAnchor),
            title.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    func configure(texet: String, font: UIFont?, textColor: UIColor) {
        title.text = texet
        title.font = font
        title.textColor = textColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
