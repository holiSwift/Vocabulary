//
//  ListViewController.swift
//  dictionary
//
//  Created by Виталий Орехов on 18.05.21.
//

import UIKit
import Firebase
import FirebaseFirestore

class ListViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var ref: DatabaseReference?
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.FStore.cellIdentifier, for: indexPath) as! RowViewCell
        cell.word.setTitle(message.key, for: .normal)
        cell.translate.setTitle(message.value, for: .normal)
            
        return cell
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        tableView.dataSource = self
        tableView.register(UINib(nibName: "RowViewCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        loadMessages()
     
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
                        DispatchQueue.main.async {
                            self.messages.sort(by: {$0.key > $1.key})
                            self.tableView.reloadData()
                            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                            
                        }
                    }
                }
            }
        }


}

 

