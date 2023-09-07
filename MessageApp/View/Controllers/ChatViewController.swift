//
//  ChatViewController.swift
//  MessageApp
//
//  Created by Eyüphan Akkaya on 7.09.2023.
//

import UIKit
import MessageKit

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

struct Message: MessageType {
    var messageId: String
    var sentDate: Date
    var sender: SenderType
    var kind: MessageKind
}

class ChatViewController: MessagesViewController {
   
    let currentUser = Sender(senderId: "self", displayName: "eyp")
    var messages = [MessageType]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self

        // Örnek bir mesaj ekleyelim
        let initialMessage = Message(messageId: "1", sentDate: Date().addingTimeInterval(-86400), sender: currentUser, kind: .text("Hello, world"))
        messages.append(initialMessage)
        
        messagesCollectionView.reloadData() // Mesajları görüntülemek için koleksiyonu yeniden yükleyin
    }

    // MessagesDataSource'dan gelen işlevler

}
extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    var currentSender: MessageKit.SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
}
