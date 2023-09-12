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
            // Şimdi fetchPersons işlevini çağırabilirsiniz
           // fetchPersons()
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
                        let messages = Users(image: "", name: "", lastName: "", email: receiver, password: "", sender: sender, receiver: receiver, message: message, time: Date().timeIntervalSince1970)
                        // Kullanıcının kimliğini belirleyin (mesajı gönderen veya alan)
                        let otherUserId = (self.loggedInUserId == sender) ? receiver : sender
                        
                        // Kullanıcının son mesajını güncelleyin veya ekleyin
                        if let existingMessage = latestMessages[otherUserId] {
                            // Eğer kullanıcının daha önce mesajı varsa, tarihine göre karşılaştırın
                            if messages.time ?? 0 > existingMessage.time ?? 0 {
                                latestMessages[otherUserId] = messages
                            }
                        } else {
                            // Eğer kullanıcının henüz mesajı yoksa, ekleyin
                            latestMessages[otherUserId] = messages
                        }
                    }
                }
                
                // Verileri çektikten sonra tabloyu güncelle
                self.messageList = Array(latestMessages.values) // Son mesajları listeye çevirin
              
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
    }
//    func fetchPersons() {
//        ref?.child("Users").observe(.value, with: { snapshot in
//            if let gelenVeri = snapshot.value as? [String: Any] {
//                for gelenSatir in gelenVeri {
//                    if let sozluk = gelenSatir.value as? NSDictionary {
//                        guard let image = sozluk["image"] as? String,
//                              let name = sozluk["name"] as? String,
//                              let lastName = sozluk["lastName"] as? String,
//                              let email = sozluk["email"] as? String,
//                              let password = sozluk["password"] as? String else{
//                            return
//                        }
//                        let myUsersItem = Users(image: "", name: name, lastName: lastName, email: email, password: password, sender: "", receiver: "", message: "", time: 0)
//                        self.myMessagesList.append(myUsersItem)
//                    }
//                }
//                for (index, user) in self.myMessagesList.enumerated() {
//                    // Kullanıcının bilgilerini karşılaştırın (örneğin, kullanıcı adıyla karşılaştırma yapabilirsiniz)
//                    if user.email == self.loggedInUserId {
//                        // Giriş yapan kullanıcıyı listeden kaldırın
//                        self.myMessagesList.remove(at: index)
//                        break // Kullanıcıyı bulduktan sonra döngüden çıkın
//                    }
//                }
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//
//                }
//            }
//        })
//    }
    
}
