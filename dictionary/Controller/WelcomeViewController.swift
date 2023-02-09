//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit


class WelcomeViewController: UIViewController {

   // Navigate controller is hidden
    override func viewDidLoad(){
       super.viewDidLoad()
       self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
       self.navigationController!.navigationBar.shadowImage = UIImage()
       self.navigationController!.navigationBar.isTranslucent = true        
    }
}
