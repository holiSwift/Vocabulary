//
//  RusVC.swift
//  dictionary
//
//  Created by Виталий Орехов on 7.05.21.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseDatabase

class RusVC: UIViewController {
    @IBOutlet weak var rusWord: UILabel!
    @IBOutlet weak var engField: UITextField!
    @IBOutlet weak var checkBtn: UIButton!
    
    var ref: DatabaseReference?
    let db = Firestore.firestore()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        checkBtn.isHidden = true
        engField.isHidden = true
        rusWord.text = " "
        
        ref = Database.database().reference()

        updateUI()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }


    @objc func updateUI() {
        engField.text = ""
        engField.backgroundColor = UIColor.clear
  
        let user =  Auth.auth().currentUser?.email
        let docRef = db.collection(K.FStore.collectionName).document(user!)
         docRef.getDocument { [self] (document, error) in

            if let document = document, document.exists {

                let document = document
                let label = document.data()?.values.randomElement()!
                self.rusWord.text = label as? String
                
                    // Fit the label into screen
                self.rusWord.adjustsFontSizeToFitWidth = true
                
                self.checkBtn.isHidden = false
                self.engField.isHidden = false

            } else {

                self.checkBtn.isHidden = true
                self.engField.isHidden = true
                self.rusWord.adjustsFontSizeToFitWidth = true

                   }
         }
    }
    

    @IBAction func checkBtnPress(_ sender: Any) {
        
                let user =  Auth.auth().currentUser?.email
                let docRef = db.collection(K.FStore.collectionName).document(user!)
                docRef.getDocument { (document, error) in
                    let document = document
                    let label = self.rusWord.text!
                    let translateField = self.engField.text!.lowercased().trimmingCharacters(in: .whitespaces)
                    
                    let array = document?.data()
                    
                    let values = array?.values.compactMap{$0 as? String}
                    
                    let commonIndex = values!.firstIndex(of: label)!
                    
                    let keysArray = array?.keys.compactMap{$0}
                    let key = keysArray![commonIndex]

                    if translateField == key {
                        self.engField.backgroundColor = UIColor.green
                    } else {
                        self.engField.backgroundColor = UIColor.red
                        self.engField.shaking()
                    }
                       
                 Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.updateUI), userInfo: nil, repeats: false)
                 }
            }
    
    }
    
    extension UITextField {
        func shaking() {
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.05
            animation.repeatCount = 5
            animation.autoreverses = true
            animation.fromValue = CGPoint(x: self.center.x - 4.0, y: self.center.y)
            animation.toValue = CGPoint(x: self.center.x + 4.0, y: self.center.y)
            layer.add(animation, forKey: "position")
        }
    }

