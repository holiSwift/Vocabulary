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

class RUSViewController: UIViewController {
    @IBOutlet weak var mainTextLabel: UILabel!
    @IBOutlet weak var translateTextField: UITextField!
    @IBOutlet weak var checkButton: UIButton!
    
    var ref: DatabaseReference?
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTextLabel.text = " "
        checkButton.isHidden = true
        translateTextField.isHidden = true
        
        ref = Database.database().reference()
        updateUI()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
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
   
    private func hideShowViews(shouldHide: Bool, textLable: String?) {
        checkButton.isHidden = shouldHide
        translateTextField.isHidden = shouldHide
        mainTextLabel.adjustsFontSizeToFitWidth = true
        mainTextLabel.text = textLable ?? "Add your first word to book"
    }


    func updateUI() {
        
        translateTextField.text = ""
        translateTextField.backgroundColor = UIColor.clear
        
        fetchDocument { [weak self] error in
            self?.hideShowViews(shouldHide: true, textLable: nil)
        } completion: { [weak self] document in
            
            if let userFirebaseDocument = document, userFirebaseDocument.exists {
                
                let mainTextLable = userFirebaseDocument.data()?.values.randomElement()
                
                self?.hideShowViews(shouldHide: false, textLable: mainTextLable as? String)
                
            } else {
                
                self?.hideShowViews(shouldHide: true, textLable: nil)
            }
        }
    }
    

    @IBAction func pressCheckButton(_ sender: Any) {
        
        fetchDocument { error in
        } completion: { [weak self] document in
            
            let currenetTextLable = self!.mainTextLabel.text!
            let arrayOfValues = document?.data()!.values.compactMap{$0 as? String}
            let currentValueIndex = arrayOfValues!.firstIndex(of: currenetTextLable)!
            let currentKey = document?.data()?.keys.compactMap{$0}[currentValueIndex]
            let currentTranslateTextField = self!.translateTextField.text!.lowercased().trimmingCharacters(in: .whitespaces)

            if currentTranslateTextField == currentKey {
                
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


