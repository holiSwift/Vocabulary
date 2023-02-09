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
    
    @IBOutlet weak var mainTextLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var translateTextField: UITextField!
    
    let functionality = TextFieldFunctionality()

    var ref: DatabaseReference?
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

        translateTextField.backgroundColor = .clear
        translateTextField.layer.borderWidth = 2
        translateTextField.layer.borderColor =  UIColor(white: 1.0, alpha: 0.1).cgColor
        
        checkButton.isHidden = true
        translateTextField.isHidden = true
        mainTextLabel.text = " "
        
        ref = Database.database().reference()
        
        updateUI()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
   
    @IBAction func pressCheckButton(_ sender: UIButton) {
        isTranslateRight()
    }
}


extension ViewController {
    
    enum Error {
        case invalidUser
        case noDocumentFound
    }
    
    func isStartView(isInitialView: Bool, mainlLabel: String?, textField: UITextField, checkButton: UIButton){
        checkButton.isHidden = isInitialView
        textField.isHidden = isInitialView
        mainTextLabel.adjustsFontSizeToFitWidth = true
        mainTextLabel.text = mainlLabel ?? "Add your word to book"
    }

    func fetchDocument(onError: @escaping (Error) -> (), completion: @escaping (DocumentSnapshot?) -> ())  {
        guard let currentUser = Auth.auth().currentUser?.email else {
            onError(.invalidUser)
            return
        }
        db.collection(Constans.FStore.collectionName).document(currentUser).getDocument { (document, error) in
            if let error = error {
                onError(.noDocumentFound)
                print(error)
            } else {
                completion(document!)
            }
        }
    }
    
    func updateUI() {

        translateTextField.text = ""
        translateTextField.backgroundColor = UIColor.clear

        fetchDocument { [weak self] error in
            self?.isStartView(isInitialView: true, mainlLabel: nil, textField: self!.translateTextField, checkButton: self!.checkButton)
        } completion: { [weak self] document in

            if let userFirebaseDocument = document, userFirebaseDocument.exists {
                self?.isStartView(isInitialView: false, mainlLabel: userFirebaseDocument.data()?.keys.randomElement(), textField: self!.translateTextField, checkButton: self!.checkButton)
            } else {
                self?.isStartView(isInitialView: true, mainlLabel: nil, textField: self!.translateTextField, checkButton: self!.checkButton)
            }
        }
    }
    
    func isTranslateRight(){
        fetchDocument { error in
        } completion: { [weak self] document in
            
            let currenetTextLable = self!.mainTextLabel.text!
            let firebaseValue = document!.get(currenetTextLable) as? String
            let currentTranslate = self!.translateTextField.text!.lowercased().trimmingCharacters(in: .whitespaces)

            if currentTranslate == firebaseValue {
                self!.functionality.rightAnswwer(textField: self!.translateTextField)
                self!.updateUI()
            } else {
                self!.functionality.wrongAnswer(textField: self!.translateTextField)
            }
        }
    }
}







