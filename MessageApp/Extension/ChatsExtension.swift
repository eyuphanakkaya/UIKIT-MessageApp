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
        
        let mesaj =  Users(image: "", name: "", lastName: "", email: "", password: "", sender: senderUser ?? "", receiver: person?.email ?? "", message: text, time: Date().timeIntervalSince1970)
        let dict: [String: Any] = ["sender": mesaj.sender,"receiver": mesaj.receiver,"message": mesaj.message,"time": mesaj.time ] 
        let newRef = ref?.child("Messages").childByAutoId()
        newRef?.setValue(dict)
       
        
        // Metin girişini temizle
        inputBar.inputTextView.text = ""
        
    }
    
    
    
}
