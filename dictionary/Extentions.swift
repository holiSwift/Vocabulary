//
//  Extentions.swift
//  dictionary
//
//  Created by Виталий Орехов on 28.09.21.
//

import UIKit

extension UITextField {
    
    func shakeAndHighlight() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: self.center.x - 4.0, y: self.center.y)
        animation.toValue = CGPoint(x: self.center.x + 4.0, y: self.center.y)
        layer.add(animation, forKey: "position")

            layer.backgroundColor = CGColor.init(red: 255, green: 0, blue: 0, alpha: 1)
        }
    
    
}
