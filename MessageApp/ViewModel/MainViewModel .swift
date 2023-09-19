//
//  ViewModel .swift
//  MessageApp
//
//  Created by Eyüphan Akkaya on 15.09.2023.
//

import Foundation
import Firebase
import FirebaseStorage

class MainViewModel {
    var myUsers = [Users]()
    var ref: DatabaseReference?
    var myReceiver = [String]()
    var myImage: [String: UIImage] = [:]
    var messageList = [Users]()
    var searchActive = true
    var searchList = [Users]()
    var loggedInUserId: String?
    var myImageState = true
    var cache = ImageCache()
    
  
    init() {
        if let user = Auth.auth().currentUser {
            loggedInUserId = user.email
        }
        ref = Database.database().reference()
    }
    func fetchProfileImagesForReceivers(tableView: UITableView) {
        let storageRef = Storage.storage().reference()

        for receiverEmail in myReceiver {
            if let cacheImage = ImageCache.getImage(forKey: receiverEmail) {
                self.myImage[receiverEmail] = cacheImage
            } else {
                let imageRef = storageRef.child("images/\(receiverEmail)/resim.jpg")
                imageRef.getData(maxSize: 1 * 1024 * 1024) { [weak self, receiverEmail] data, error in
                    if let error = error {
                        self?.myImageState = false
                        print("Resim indirme hatası (\(receiverEmail)): \(error.localizedDescription)")
                    } else if let data = data, let image = UIImage(data: data) {
                        self?.myImage[receiverEmail] = image
                        ImageCache.saveImage(image, forKey: receiverEmail) // Resmi yerel önbelleğe kaydedin
                        self?.myImageState = true
                        DispatchQueue.main.async {
                            tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func fetchMessagePersons(tableView: UITableView) {
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
                                self.myReceiver.append(otherUserId)
                                
                                
                                
                            }
                        }
                    }
                }
                
                // Verileri çektikten sonra tabloyu güncelle
                self.messageList = Array(latestMessages.values) // Son mesajları listeye çevirin
                // Son mesajları tarihe göre sıralayın
                self.messageList.sort(by: { $0.time ?? 0 > $1.time ?? 0 })
                DispatchQueue.main.async {
                    tableView.reloadData()
                }
            }
        })
    }

}

