//
//  ChatModel.swift
//  IChat
//
//  Created by kris on 23/09/2020.
//  Copyright © 2020 kris. All rights reserved.
//

import UIKit
import FirebaseFirestore

struct Mchat: Hashable, Decodable {
    
    var friendUsername: String
    var friendavatarStringURL: String
    var lastMessage: String
    var friendId: String
    
    var representation: [String : Any] {
        var rep = ["friendUsername": friendUsername]
        rep["friendavatarStringURL"] = friendavatarStringURL
        rep["lastMessage"] = lastMessage
        rep["friendId"] = friendId
        return rep
    }
    
    init(friendUsername: String, friendavatarStringURL: String, lastMessage: String, friendId: String) {
        self.friendUsername = friendUsername
        self.friendavatarStringURL = friendavatarStringURL
        self.lastMessage = lastMessage
        self.friendId = friendId
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let friendUsername = data["friendUsername"] as? String,
            let friendavatarStringURL = data["friendavatarStringURL"] as? String,
            let lastMessage = data["lastMessage"] as? String,
            let friendId = data["friendId"] as? String else {return nil}
        
        self.friendUsername = friendUsername
        self.friendavatarStringURL = friendavatarStringURL
        self.lastMessage = lastMessage
        self.friendId = friendId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(friendId)
    }
    
    static func ==(lhs: Mchat, rhs: Mchat) -> Bool {
        return lhs.friendId == rhs.friendId
    }
}
