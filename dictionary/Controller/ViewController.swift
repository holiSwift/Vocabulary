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
    
    @IBAction func logoOutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    
    enum Error {
        case invalidUser
        case noDocumentFound
    }

    func fetchDocument(onError: @escaping (Error) -> (), completion: @escaping (DocumentSnapshot?) -> ())  {
        guard let user = Auth.auth().currentUser?.email else {
            onError(.invalidUser)
            return
        }
        db.collection(K.FStore.collectionName).document(user).getDocument { (document, error) in
            if let error = error {
                onError(.noDocumentFound)
                print(error)
            } else {
                completion(document!)
            }
        }
    }
   
    private func hideShowViews(shouldHide: Bool, newWordText: String?) {
        checkButton.isHidden = shouldHide
        inputTranslate.isHidden = shouldHide
        deleteBtn.isHidden = shouldHide
        someNewWord.adjustsFontSizeToFitWidth = true
        someNewWord.text = newWordText ?? "Add your first word to translate"
    }
    
    
    func updateUI() {
        inputTranslate.text = ""
        inputTranslate.backgroundColor = UIColor.clear
        
        fetchDocument { [weak self] error in
            self?.hideShowViews(shouldHide: true, newWordText: nil)
        } completion: { [weak self] document in
            
            if let document = document, document.exists {
                self?.hideShowViews(shouldHide: false, newWordText: document.data()?.keys.randomElement())
            } else {
                self?.hideShowViews(shouldHide: true, newWordText: nil)
            }
        }
    }
    
//    enum TrueOrFalse{
//        case answerIsTrue
//        case answerIsFalse
//    }
//    private func textfieldBgColor(answer: Bool, bgColor: UIColor){
//        
//    }
//       
    @IBAction func checkButton(_ sender: UIButton) {
        
        fetchDocument { error in
        } completion: { [weak self] document in
            
            let label = self!.someNewWord.text!
            let currentTranslate = document!.get(label) as? String
            let translateField = self!.inputTranslate.text!.lowercased().trimmingCharacters(in: .whitespaces)

            if translateField == currentTranslate {
                self!.inputTranslate.backgroundColor = UIColor.green
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                    self!.inputTranslate.backgroundColor = UIColor.clear
                    self!.updateUI()
                }
            } else {
                self!.inputTranslate.backgroundColor = UIColor.red
                self!.inputTranslate.shakingAndRedBg()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                    self!.inputTranslate.backgroundColor = UIColor.clear
                    self!.inputTranslate.text = ""
                }
            }
        }
    }

    func deletCurrentWord () {
        
        fetchDocument {  error in
        } completion: { [weak self] document in
            
            let  array = document!.data()
            let counter = array!.count
            
            if counter == 1 {
                
                        // Whole document will be deleted.
                let user =  Auth.auth().currentUser?.email
                self!.db.collection(K.FStore.collectionName).document(user!).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        self!.updateUI()
                    }
                }
                
            } else {
                        // Current word will be deleted
                let user =  Auth.auth().currentUser?.email
                let wordForDelete  = self!.someNewWord.text!
                self!.db.collection(K.FStore.collectionName).document(user!).updateData([
                        wordForDelete: FieldValue.delete()
                            ]) { err in
                            if let err = err {
                                print("Error updating document: \(err)")
                            } else {
                                self!.updateUI()
                                }
                    }
                }

            }
        }
}
