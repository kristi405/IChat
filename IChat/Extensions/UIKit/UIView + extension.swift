//
//  UIView + extension.swift
//  IChat
//
//  Created by kris on 29/09/2020.
//  Copyright © 2020 kris. All rights reserved.
//

import UIKit

extension UIView {
    
    func applyGradient(cornerRadius: CGFloat) {
        
        self.backgroundColor = nil
        self.layoutIfNeeded()
        let gradientView = GradientView(from: .topTrailing, to: .bottomLeading, startColor: #colorLiteral(red: 0.8941176471, green: 0.6431372549, blue: 0.937254902, alpha: 1), endColor: #colorLiteral(red: 0.4392156863, green: 0.7568627451, blue: 0.937254902, alpha: 1))
        if let gradientLayer = gradientView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = self.bounds
            gradientLayer.cornerRadius = cornerRadius
        
        self.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
}
