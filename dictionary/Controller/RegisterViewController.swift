//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase


class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var retypePasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextfield.backgroundColor = .clear
        emailTextfield.layer.borderWidth = 2
        emailTextfield.layer.borderColor =  UIColor(white: 1.0, alpha: 0.1).cgColor
        passwordTextfield.backgroundColor = .clear
        passwordTextfield.layer.borderWidth = 2
        passwordTextfield.layer.borderColor =  UIColor(white: 1.0, alpha: 0.1).cgColor
        retypePasswordTextField.backgroundColor = .clear
        retypePasswordTextField.layer.borderWidth = 2
        retypePasswordTextField.layer.borderColor =  UIColor(white: 1.0, alpha: 0.1).cgColor
    }
        
    @IBAction func pressSignupButton(_ sender: UIButton) {
       
        if let email = emailTextfield.text,
           let password = passwordTextfield.text,
           retypePasswordTextField.text == passwordTextfield.text {
            Auth.auth().createUser(withEmail: email, password: password) { [self] authResult, error in
                if let e = error {
                    print(e)
                    self.emailTextfield.shakeAndHighlight()
                    self.passwordTextfield.shakeAndHighlight()
                    self.retypePasswordTextField.shakeAndHighlight()
                    cleanTextField()
                } else {
                    self.performSegue(withIdentifier: "RegisterSegue", sender: self)
                }
            }
        } else if retypePasswordTextField.text != passwordTextfield.text {
            self.passwordTextfield.shakeAndHighlight()
            self.retypePasswordTextField.shakeAndHighlight()
            cleanTextField()
        }
    }
    
    func cleanTextField(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.emailTextfield.backgroundColor = UIColor.clear
            self.passwordTextfield.backgroundColor = UIColor.clear
            self.retypePasswordTextField.backgroundColor = UIColor.clear
        }
    }
    
}
