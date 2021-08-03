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
    @IBOutlet weak var retypePassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
        
    @IBAction func registerPressed(_ sender: UIButton) {
       
        if let email = emailTextfield.text, let password = passwordTextfield.text, retypePassword.text == passwordTextfield.text {
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                
                if let e = error {
                    
                    print(e)
                    self.emailTextfield.shakingAndRedBg()
                    self.passwordTextfield.shakingAndRedBg()
                    self.retypePassword.shakingAndRedBg()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.emailTextfield.backgroundColor = UIColor.clear
                        self.passwordTextfield.backgroundColor = UIColor.clear
                        self.retypePassword.backgroundColor = UIColor.clear
                    }
                } else {
                    self.performSegue(withIdentifier: "RegisterSegue", sender: self)
                    
                }
            }
        } else if retypePassword.text != passwordTextfield.text {
            self.emailTextfield.shakingAndRedBg()
            self.passwordTextfield.shakingAndRedBg()
            self.retypePassword.shakingAndRedBg()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.emailTextfield.backgroundColor = UIColor.clear
                self.passwordTextfield.backgroundColor = UIColor.clear
                self.retypePassword.backgroundColor = UIColor.clear
            }
        }
    }
    
}
