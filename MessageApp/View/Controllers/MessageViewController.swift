//
//  MessageViewController.swift
//  MessageApp
//
//  Created by Eyüphan Akkaya on 6.09.2023.
//

import UIKit
import Firebase

class MessageViewController: UIViewController {
    var ref: DatabaseReference?
    var searchActive = true
    var messageList = [Users]()
    var searchList = [Users]()
    var loggedInUserId: String?
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        messageList.sort(by: { $0.receiver ?? "" < $1.receiver ?? "" })
        if let user = Auth.auth().currentUser {
            self.loggedInUserId = user.email
            fetchMessagePersons()
        }
       
    }
    func fetchMessagePersons() {
        ref?.child("Messages").observe(.value, with: { snapshot in
            var latestMessages = [String: Users]() // Kullanıcı kimliği ile son mesajları depolamak için bir sözlük

            if let incomingData = snapshot.value as? [String: Any] {
                for incominLine in incomingData {
                    if let dict = incominLine.value as? NSDictionary {
                        guard let sender = dict["sender"] as? String,
                            let receiver = dict["receiver"] as? String,
                            let message = dict["message"] as? String else {
                                print("Mesaja veri gelmedi HATAA!!!")
                                return
                        }
                        
                        // Sadece giriş yapan kullanıcının gönderdiği veya aldığı mesajları alın
                        if sender == self.loggedInUserId || receiver == self.loggedInUserId {
                            let messages = Users(image: "", name: "", lastName: "", email: sender == self.loggedInUserId ? receiver : sender, password: "", sender: sender, receiver: receiver, message: message, time: Date().timeIntervalSince1970)

                            // Kullanıcının kimliğini belirleyin (mesajı gönderen veya alan)
                            let otherUserId = (self.loggedInUserId == sender) ? receiver : sender

                            // Eğer kullanıcının daha önce mesajı varsa, tarihine göre karşılaştırın
                            if let existingMessage = latestMessages[otherUserId] {
                                if messages.time ?? 0 > existingMessage.time ?? 0 {
                                    latestMessages[otherUserId] = messages
                                }
                            } else {
                                // Eğer kullanıcının henüz mesajı yoksa, ekleyin
                                latestMessages[otherUserId] = messages
                            }
                        }
                    }
                }

                // Verileri çektikten sonra tabloyu güncelle
                self.messageList = Array(latestMessages.values) // Son mesajları listeye çevirin

                // Son mesajları tarihe göre sıralayın
                self.messageList.sort(by: { $0.time ?? 0 > $1.time ?? 0 })

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
    }
}
