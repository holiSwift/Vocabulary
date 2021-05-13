//
//  SecondViewController.swift
//  dictionary
//
//  Created by Виталий Орехов on 1.03.21.
//

import UIKit
import Firebase
import FirebaseFirestore

class AddNewWordVC: UIViewController {
    
    @IBOutlet weak var wordField: UITextField!
    @IBOutlet weak var translateField: UITextField!
    @IBOutlet weak var enterBtn: UIButton!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        Hidding the keyboard by taping the view
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
  
        view.endEditing(true)
    }
    
    
    func addWordToList() {
        
        if let usersWordBody = wordField.text?.lowercased().trimmingCharacters(in: .whitespaces),
           let translateOfUserWord = translateField.text?.lowercased().trimmingCharacters(in: .whitespaces),
           let user =  Auth.auth().currentUser?.email  {
            
                let docRef = db.collection(K.FStore.collectionName).document(user)
                docRef.getDocument { (document, error) in
                    
                    if document!.exists {
                        
                        self.db.collection(K.FStore.collectionName).document(user).updateData([
                            
                            usersWordBody: translateOfUserWord

                        ]) { [self]   (error) in
                                if let e = error {
                                    print("Something get wrong, \(e)")
                                } else {
                                    textFieldShouldClear()
                                }
                            }
                      } else {
                        
                        self.db.collection(K.FStore.collectionName).document(user).setData([
                            usersWordBody: translateOfUserWord
                            ]) {  (error) in
                                if let e = error {
                                    print("Something get wrong, \(e)")
                                } else {
                                    self.textFieldShouldClear()
                                    }
                               }
                          }
                    }
         }
    }
    
    func textFieldShouldClear(){
        wordField.text = nil
        translateField.text = nil
    }
    
    
    @IBAction func enterBtn(_ sender: UIButton) {
            let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you entered the correct data?", preferredStyle: .alert)
            let yes = UIAlertAction(title: "YES", style: .default, handler: { [self] (action) -> Void in addWordToList()})
            let check = UIAlertAction(title: "CHECK", style: .default, handler: {  (action) -> Void in })
            dialogMessage.addAction(yes)
            dialogMessage.addAction(check)
            self.present(dialogMessage, animated: true, completion: nil)
                        
    }
}

