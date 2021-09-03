//
//  RusTVCell.swift
//  dictionary
//
//  Created by Виталий Орехов on 3.09.21.
//

import UIKit
import Firebase
import FirebaseFirestore

class RusTVCell: UITableViewController {
    
    var wTextField = UITextField()
    var tTextField = UITextField()

    var ref: DatabaseReference?
    let db = Firestore.firestore()
    
    var messages: [Message] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundView = UIImageView(image: UIImage(named: "peaceful-blur-background-ipad-air-wallpaper-ilikewallpaper_com_2732x2732"))
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        tableView.dataSource = self
        tableView.register(UINib(nibName: "RowViewCell", bundle: nil), forCellReuseIdentifier: "RowViewCell")

        loadMessages()
    }
    

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "RowViewCell", for: indexPath) as! RowViewCell

        cell.word?.text = message.value
        cell.translate?.text = message.key
        
        return cell
    }
    
    //MARK - TableView Delegates Mehods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       tableView.deselectRow(at: indexPath, animated: true)
   }
    
    
    func loadMessages() {
        let user =  Auth.auth().currentUser?.email
        let docRef = db.collection(K.FStore.collectionName).document(user!)
        docRef.addSnapshotListener { (querySnapshot, error) in

            self.messages = []

            if let e = error {
                print(e)
            } else {
                if let snapshotDocuments = querySnapshot?.data(){

                    for item in snapshotDocuments {

                        if let key = item.key as? String, let translate = item.value as? String {

                            let newMessage = Message(key: key, value: translate)
                            self.messages.append(newMessage)
                        }
                    }
                    DispatchQueue.main.async { [self] in

                            self.messages.sort(by:  {$0.value > $1.value})
                            self.tableView.reloadData()
                            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)

                        }
                    }
                }
            }
        }
    
    
    func addWordToList() {
        print ("addWordToList")
        
        if let usersWordBody = wTextField.text?.lowercased().trimmingCharacters(in: .whitespaces),
           let translateOfUserWord = tTextField.text?.lowercased().trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .whitespacesAndNewlines),
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
    
    @IBAction func addButton(_ sender: Any) {

    
        let alert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        let dissmis = UIAlertAction(title: "CANCEL", style: .default, handler: {  (action) -> Void in })
        let action = UIAlertAction(title: "ADD", style: .default) { (action) in
            self.addWordToList()
            self.loadMessages()
        }
        
            alert.addAction(dissmis)
            alert.addTextField { (wordTextField) in
            wordTextField.placeholder = "word"
            self.wTextField = wordTextField
        }
        
            alert.addTextField { (translateTextField) in
            translateTextField.placeholder = "translate"
            self.tTextField = translateTextField
        }
        
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    
    
    func textFieldShouldClear(){
        wTextField.text = nil
        tTextField.text = nil
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let wordForDelete  = messages[indexPath.row]
        if editingStyle == UITableViewCell.EditingStyle.delete {
            messages.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)

            
            let user =  Auth.auth().currentUser?.email
            self.db.collection(K.FStore.collectionName).document(user!).updateData([
                wordForDelete.key: FieldValue.delete()
                        ]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("deleted")
                            }
                }
        }
    }

    
}

