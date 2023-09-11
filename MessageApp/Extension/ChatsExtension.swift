//
//  ChatsExtension.swift
//  MessageApp
//
//  Created by Eyüphan Akkaya on 11.09.2023.
//

import Foundation
import UIKit
import MessageKit
import InputBarAccessoryView

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate ,InputBarAccessoryViewDelegate{
    func currentSender() -> MessageKit.SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {//mesajın indexini döndürür
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count//mesaj sayısı
    }
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
            let newMessage = Message(
                messageId: UUID().uuidString,
                sentDate: Date(),
                sender: currentUser,
                kind: .text(text)
            )
//        if !messages.contains(where: { $0.messageId == newMessage.messageId }) {
//            messages.append(newMessage)
//        }
            messagesCollectionView.reloadData()
        
        
        let mesaj = MyMessage(sender: senderUser ?? "", receiver: person?.email ?? "", message: text)
        let dict = ["sender": mesaj.sender,"receiver": mesaj.receiver,"message": mesaj.message]
        let newRef = ref?.child("Messages").childByAutoId()
        newRef?.setValue(dict)
       
        
        // Metin girişini temizle
        inputBar.inputTextView.text = ""
        
    }
    
    
    
}
