//
//  ViewController.swift
//  dictionary
//
//  Created by Виталий Орехов on 20.02.21.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseDatabase


class ViewController: UIViewController {
    
    @IBOutlet weak var someNewWord: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var inputTranslate: UITextField!
    @IBOutlet weak var addBtnPrsd: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!

    
    var ref: DatabaseReference?
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        checkButton.isHidden = true
        inputTranslate.isHidden = true
        deleteBtn.isHidden = true
        someNewWord.text = " "
        
        ref = Database.database().reference()

        updateUI()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
      
    
    @objc func updateUI() {
        inputTranslate.text = ""
        inputTranslate.backgroundColor = UIColor.clear
  
        let user =  Auth.auth().currentUser?.email
        let docRef = db.collection(K.FStore.collectionName).document(user!)
         docRef.getDocument { [self] (document, error) in

            if let document = document, document.exists {

                let document = document
                let label = document.data()?.keys.randomElement()!
                self.someNewWord.text = label
                
                    // Fit the label into screen
                self.someNewWord.adjustsFontSizeToFitWidth = true
                
                self.checkButton.isHidden = false
                self.inputTranslate.isHidden = false
                self.deleteBtn.isHidden = false

            } else {

                self.checkButton.isHidden = true
                self.inputTranslate.isHidden = true
                self.deleteBtn.isHidden = true
                self.someNewWord.adjustsFontSizeToFitWidth = true

                   }
         }
    }
              
    @IBAction func checkButton(_ sender: UIButton) {
        
        let user =  Auth.auth().currentUser?.email
        let docRef = db.collection(K.FStore.collectionName).document(user!)
        docRef.getDocument { (document, error) in
            let document = document
            
            let label = self.someNewWord.text!
            let currentTranslate = document!.get(label) as? String

            let translateField = self.inputTranslate.text!.lowercased().trimmingCharacters(in: .whitespaces)

            if translateField == currentTranslate {
                self.inputTranslate.backgroundColor = UIColor.green
            } else {
                self.inputTranslate.backgroundColor = UIColor.red
                self.inputTranslate.shake()
           }
         Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.updateUI), userInfo: nil, repeats: false)
         }
    }

    func deletCurrentWord () {
    
        let user =  Auth.auth().currentUser?.email
        let docRef = db.collection(K.FStore.collectionName).document(user!)
        docRef.getDocument { (document, err) in
            let document = document
            if let err = err {
                print("Error getting documents: \(err)")
                
            } else {
                  
                let  array = document!.data()
                let counter = array!.count
                print(counter)
                    
            if counter == 1 {
                        
                        // The whole document will deleted together with a last word in list.
                let user =  Auth.auth().currentUser?.email
                self.db.collection(K.FStore.collectionName).document(user!).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        self.updateUI()
                    }
                }
                            
            } else {
                // A current word will deleted

                let user =  Auth.auth().currentUser?.email
                let wordForDelete  = self.someNewWord.text!
                        
                self.db.collection(K.FStore.collectionName).document(user!).updateData([
                    wordForDelete: FieldValue.delete()
                        ]) { err in
                                
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            self.updateUI()
                            }
                        }
                    }
                }
        }
    }

        

    @IBAction func deleteBtnWasPressed(_ sender: Any) {
    
         let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure?", preferredStyle: .alert)
        
         let yes = UIAlertAction(title: "YES", style: .default, handler: { [self] (action) -> Void in deletCurrentWord ()})
         let check = UIAlertAction(title: "No", style: .default, handler: {  (action) -> Void in })
        
         dialogMessage.addAction(yes)
         dialogMessage.addAction(check)
        
          self.present(dialogMessage, animated: true, completion: nil)
              
    }

    
    
    @IBAction func logoOutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        
    }
}


    
    extension UITextField {
        func shake() {
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.05
            animation.repeatCount = 5
            animation.autoreverses = true
            animation.fromValue = CGPoint(x: self.center.x - 4.0, y: self.center.y)
            animation.toValue = CGPoint(x: self.center.x + 4.0, y: self.center.y)
            layer.add(animation, forKey: "position")
        }
    }
    
    
    



