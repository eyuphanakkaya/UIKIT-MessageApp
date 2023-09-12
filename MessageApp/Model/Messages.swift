//
//  Messages.swift
//  MessageApp
//
//  Created by Eyüphan Akkaya on 8.09.2023.
//

import Foundation
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

