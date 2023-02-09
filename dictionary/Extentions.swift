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

struct TextFieldFunctionality {

    func wrongAnswer(textField: UITextField){
        textField.backgroundColor = UIColor.red
        textField.shakeAndHighlight()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            textField.backgroundColor = UIColor.clear
            textField.text = ""
        }
    }

    func rightAnswwer(textField: UITextField) {
        textField.backgroundColor = UIColor.green
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            textField.backgroundColor = UIColor.clear
        }
    }
}

