//
//  ChatViewController.swift
//  MessageApp
//
//  Created by Eyüphan Akkaya on 7.09.2023.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Firebase


class ChatViewController: MessagesViewController {
    var senderUser: String?
    var ref: DatabaseReference?
    var person: Users?
    var messageList = [Users]()
    let currentUser = Sender(senderId: "self", displayName: "eyp")
    let otherUser = Sender(senderId: "user", displayName: "eyp1")
    var messages = [MessageType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self as InputBarAccessoryViewDelegate
        fetchMessages()
    }
    func fetchMessages() {
        // Firebase verilerini çekmek için Firebase işlemini başlatın
        ref?.child("Messages").observe(.childAdded, with: { [weak self] snapshot in
            guard let self = self else { return }
            guard let messageData = snapshot.value as? [String: Any] else { return }

            // Verileri işleyin ve messages dizisine ekleyin
            if let sender = messageData["sender"] as? String,
               let receiver = messageData["receiver"] as? String,
               let messageText = messageData["message"] as? String {
               
               // Giriş yapan kullanıcının e-postası
                let senderUsers = self.senderUser
               // Gönderen ve alıcı giriş yapan kullanıcıysa veya sadece gönderen giriş yapan kullanıcıysa mesajı ekle
                if sender == senderUsers && receiver == self.person?.email || (sender != senderUsers && receiver == senderUsers && sender == self.person?.email)  {
                   let message = Message(
                       messageId: UUID().uuidString,
                       sentDate: Date(),
                       sender: sender == senderUsers ? self.currentUser : self.otherUser,
                       kind: .text(messageText)
                   )
                   self.messages.append(message)
                
                   
                   // Gelen her mesajı görüntülemeyi güncelleyin
                   self.messagesCollectionView.reloadData()
                }
           }
       })
    }



    
}


