//
//  ListTableViewCell.swift
//  dictionary
//
//  Created by Виталий Орехов on 28.09.21.
//

import UIKit
import Firebase
//import FirebaseFirestore

class LibraryTableViewCell: UITableViewController, UISearchBarDelegate, UISearchControllerDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
 
    var alertWordTextField = UITextField()
    var alertTranslateTextField = UITextField()

    var ref: DatabaseReference?
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    var filteredMessages: [Message] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage()
        searchBar.backgroundImage = image
        searchBar.tintColor = .clear
        searchBar.delegate = self
        tableView.dataSource = self
        
        loadMessages()
       
        filteredMessages = messages
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        tableView.backgroundView = UIImageView(image: UIImage(named: "background"))

    }
    

    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMessages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = filteredMessages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListSegue", for: indexPath)
        cell.textLabel?.text = message.key + " - " + message.value
        cell.textLabel?.textColor = .white
        return cell
    }
    
    // MARK: - TableView Delegates Mehods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       tableView.deselectRow(at: indexPath, animated: true)
   }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredMessages = []
        if searchText == "" {
            
            filteredMessages = messages
        }else{
            for item in messages {
                if item.key.lowercased().contains(searchText.lowercased()){

                    if let key = item.key as? String, let translate = item.value as? String {
    
                        let newMessage = Message(key: key, value: translate)
                        self.filteredMessages.append(newMessage)
                    }
                }
            }
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let wordForDelete  = filteredMessages[indexPath.row]
        if editingStyle == UITableViewCell.EditingStyle.delete {
            filteredMessages.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)

            let user =  Auth.auth().currentUser?.email
            self.db.collection(Constans.FStore.collectionName).document(user!).updateData([
                wordForDelete.key: FieldValue.delete()
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("deleted")
                }
            }
        }
        self.tableView.reloadData()
    }
    
    
    @IBAction func addButton(_ sender: Any) {
        let alert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        let dissmis = UIAlertAction(title: "CANCEL", style: .default, handler: {  (action) -> Void in })
        let action = UIAlertAction(title: "ADD", style: .default) { (action) in
            self.addWordToList()
            self.tableView.reloadData()
        }
        
            alert.addAction(dissmis)
            alert.addTextField { (wordTextField) in
            wordTextField.placeholder = "word"
                self.alertWordTextField = wordTextField
        }
        
            alert.addTextField { (translateTextField) in
            translateTextField.placeholder = "перевод"
            self.alertTranslateTextField = translateTextField
        }
        
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}

extension LibraryTableViewCell {
    
    func loadMessages() {
        let user =  Auth.auth().currentUser?.email
        let docRef = db.collection(Constans.FStore.collectionName).document(user!)
        docRef.addSnapshotListener { (querySnapshot, error) in
            self.messages = []
            if let e = error {
                print(e)
            } else {
                if let snapshotDocuments = querySnapshot?.data(){
                    var count = 0
                    for item in snapshotDocuments {
                        count += 1
                        if let key = item.key as? String, let translate = item.value as? String {
                            let newMessage = Message(key: key, value: translate)
                            self.messages.append(newMessage)
                            print(count)
                        }
                    }
                    DispatchQueue.main.async { [self] in
                            self.messages.sort(by:  {$1.key > $0.key})
                            self.filteredMessages = self.messages
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    
    func addWordToList() {
        
        if let usersWordBody = alertWordTextField.text?.lowercased().trimmingCharacters(in: .whitespaces),
           let translateOfUserWord = alertTranslateTextField.text?.lowercased().trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .whitespacesAndNewlines),
           let user =  Auth.auth().currentUser?.email  {
            
            let docRef = db.collection(Constans.FStore.collectionName).document(user)
            docRef.getDocument { (document, error) in
                
                if document!.exists {
                    
                    self.db.collection(Constans.FStore.collectionName).document(user).updateData([
                        usersWordBody: translateOfUserWord
                    ]) { [self]   (error) in
                        if let e = error {
                            print("Something get wrong, \(e)")
                        } else {
                            textFieldShouldClear()
                        }
                    }
                   
                } else {
                    
                    self.db.collection(Constans.FStore.collectionName).document(user).setData([
                        usersWordBody: translateOfUserWord
                    ]) { (error) in
                        if let e = error {
                            print("Something get wrong, \(e)")
                        } else {
                            self.textFieldShouldClear()
                        }
                    }
                }
            }
        }

        self.tableView.reloadData()
    }
    
    func textFieldShouldClear(){
        alertWordTextField.text = nil
        alertTranslateTextField.text = nil
    }
    
}
