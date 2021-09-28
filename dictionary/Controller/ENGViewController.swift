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


class ENGViewController: UIViewController {
    
    @IBOutlet weak var mainTextLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var translateTextField: UITextField!

    var ref: DatabaseReference?
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        checkButton.isHidden = true
        translateTextField.isHidden = true
        mainTextLabel.text = " "
        
        ref = Database.database().reference()
        
        updateUI()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    enum Error {
        case invalidUser
        case noDocumentFound
    }

    func fetchDocument(onError: @escaping (Error) -> (), completion: @escaping (DocumentSnapshot?) -> ())  {
        guard let currentUser = Auth.auth().currentUser?.email else {
            onError(.invalidUser)
            return
        }
        db.collection(K.FStore.collectionName).document(currentUser).getDocument { (document, error) in
            if let error = error {
                onError(.noDocumentFound)
                print(error)
            } else {
                completion(document!)
            }
        }
    }
   
    private func hideShowViews(shouldHide: Bool, mainTextLable: String?) {
        checkButton.isHidden = shouldHide
        translateTextField.isHidden = shouldHide
        mainTextLabel.adjustsFontSizeToFitWidth = true
        mainTextLabel.text = mainTextLable ?? "Add your first word to book"
    }
    
    
    func updateUI() {
        
        translateTextField.text = ""
        translateTextField.backgroundColor = UIColor.clear
        
        fetchDocument { [weak self] error in
            self?.hideShowViews(shouldHide: true, mainTextLable: nil)
        } completion: { [weak self] document in
            
            if let userFirebaseDocument = document, userFirebaseDocument.exists {
                self?.hideShowViews(shouldHide: false, mainTextLable: userFirebaseDocument.data()?.keys.randomElement())
            } else {
                self?.hideShowViews(shouldHide: true, mainTextLable: nil)
            }
        }
    }
      
    @IBAction func pressCheckButton(_ sender: UIButton) {
        
        fetchDocument { error in
        } completion: { [weak self] document in
            
            let currenetTextLable = self!.mainTextLabel.text!
            let firebaseValue = document!.get(currenetTextLable) as? String
            let currentTranslateTextField = self!.translateTextField.text!.lowercased().trimmingCharacters(in: .whitespaces)

            if currentTranslateTextField == firebaseValue {
                self!.translateTextField.backgroundColor = UIColor.green
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                    self!.translateTextField.backgroundColor = UIColor.clear
                    self!.updateUI()
                }
            } else {
                self!.translateTextField.backgroundColor = UIColor.red
                self!.translateTextField.shakeAndHighlight()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                    self!.translateTextField.backgroundColor = UIColor.clear
                    self!.translateTextField.text = ""
                }
            }
        }
    }
}
