//
//  MessageModel.swift
//  IChat
//
//  Created by kris on 03/10/2020.
//  Copyright © 2020 kris. All rights reserved.
//

import UIKit
import FirebaseFirestore
import MessageKit

struct MMessage: Hashable, MessageType {

    var content: String
    var sender: SenderType
    var sentDate: Date
    var id: String?
    
    var messageId: String {
        return id ?? UUID().uuidString
    }
    
    var kind: MessageKind {
        return .text(content)
    }
    
    init(user: MUser, content: String) {
        self.content = content
        self.sender = Sender(senderId: user.id, displayName: user.username)
        sentDate = Date()
        id = nil
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let sentDate = data["created"] as? Timestamp,
            let content = data["content"] as? String,
            let senderId = data["senderId"] as? String,
            let senderUsername = data["senderUsername"] as? String else {return nil}
        
        self.content = content
        sender = Sender(senderId: senderId, displayName: senderUsername)
        self.sentDate = sentDate.dateValue()
        self.id = document.documentID
    }
    
    var representation: [String: Any] {
        let rep: [String: Any] = [
            "senderUsername": sender.displayName,
            "senderId": sender.senderId,
            "content": content,
            "created": sentDate]
        return rep
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(messageId)
    }
    
    static func == (lhs: MMessage, rhs: MMessage) -> Bool {
        return lhs.messageId == rhs.messageId
    }
}

extension MMessage: Comparable {
    static func < (lhs: MMessage, rhs: MMessage) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
}
