//
//  LoginViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase


class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextfield.backgroundColor = .clear
        emailTextfield.layer.borderWidth = 2
        emailTextfield.layer.borderColor =  UIColor(white: 1.0, alpha: 0.1).cgColor
        passwordTextfield.backgroundColor = .clear
        passwordTextfield.layer.borderWidth = 2
        passwordTextfield.layer.borderColor =  UIColor(white: 1.0, alpha: 0.1).cgColor
        //        Hidding the keyboard by taping the view
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    

    @IBAction func pressLoginButton(_ sender: UIButton) {
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                    self.emailTextfield.shakeAndHighlight()
                    self.passwordTextfield.shakeAndHighlight()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.emailTextfield.backgroundColor = UIColor.clear
                        self.passwordTextfield.backgroundColor = UIColor.clear
                    }
                } else {
                    self.performSegue(withIdentifier: "LoginSegue", sender: self)
                }
            }
        }
    }
}


  




