//
//  UserService.swift
//  IChat
//
//  Created by kris on 01/10/2020.
//  Copyright © 2020 kris. All rights reserved.
//

import Firebase
import FirebaseFirestore

class UserService {
    
    static var shered = UserService()
    let db = Firestore.firestore()
    
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    
    private var waitingChatRef: CollectionReference {
        return db.collection(["users", currentUser.id, "waitingChats"].joined(separator: "/"))
    }
    
    private var activeChatRef: CollectionReference {
        return db.collection(["users", currentUser.id, "activeChats"].joined(separator: "/"))
    }
    
    var currentUser: MUser!
    
    func getData(user: User, complition: @escaping (Result<MUser, Error>) -> Void) {
        let docRef = usersRef.document(user.uid)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                guard let muser = MUser(document: document) else {
                    complition(.failure(UserError.canNotUnwrapToUser))
                    return
                }
                self.currentUser = muser
                complition(.success(muser))
            } else {
                complition(.failure(UserError.canNotExistUserInfo))
            }
        }
    }
    
    func saveData(id: String, email: String, username: String?, avatarImage: UIImage?, description: String?, sex: String?, complition: @escaping (Result<MUser, Error>) -> Void) {
        
        guard Validates.isField(username: username, description: description, sex: sex) else {
            complition(.failure(UserError.notFilled))
            return
        }
        
        guard avatarImage != #imageLiteral(resourceName: "avatar") else {
            complition(.failure(UserError.avatarNotExist))
            return
        }
        
        var muser = MUser(username: username!,
                          email: email,
                          description: description!,
                          avatarStringURL: "nil",
                          sex: sex!,
                          id: id)
        
        StorageService.shered.upload(photo: avatarImage!) { (result) in
            switch result {
            case .success(let url):
                muser.avatarStringURL = url.absoluteString
                self.usersRef.document(muser.id).setData(muser.representation) { (error) in
                    if let error = error {
                        complition(.failure(error))
                    } else {
                        complition(.success(muser))
                    }
                }
            case .failure(let error):
                complition(.failure(error))
            }
        }
    }
    
    func createWatingChats(message: String, reciaver: MUser, complition: @escaping (Result<Void, Error>) -> Void) {
        
        let refference = db.collection(["users", reciaver.id, "waitingChats"].joined(separator: "/"))
        let messageRef = refference.document(self.currentUser.id).collection("massage")
        
        let message = MMessage(user: currentUser, content: message)
        let chat = Mchat(friendUsername: currentUser.username,
                         friendavatarStringURL: currentUser.avatarStringURL,
                         lastMessage: message.content,
                         friendId: currentUser.id)
        
        refference.document(currentUser.id).setData(chat.representation) { (error) in
            if let error = error {
                complition(.failure(error))
                return
            }
            messageRef.addDocument(data: message.representation) { (error) in
                if let error = error {
                    complition(.failure(error))
                    return
                }
                complition(.success(Void()))
            }
        }
    }
    
    func deleteWaitingChats(chat: Mchat, complition: @escaping (Result<Void, Error>) -> Void) {
        waitingChatRef.document(chat.friendId).delete { (error) in
            if let error = error {
                complition(.failure(error))
                return
            }
            self.deleteMasseges(chat: chat, complition: complition)
        }
    }
    
    func deleteMasseges(chat: Mchat, complition: @escaping (Result<Void, Error>) -> Void) {
        let referance = waitingChatRef.document(chat.friendId).collection("massage")
        getWaitingChatMassege(chat: chat) { (result) in
            switch result {
                
            case .success(let massages):
                for massege in massages {
                    guard let documentID = massege.id else {return}
                    let massegeRef = referance.document(documentID)
                    massegeRef.delete { (error) in
                        if let error = error {
                            complition(.failure(error))
                            return
                        }
                        complition(.success(Void()))
                    }
                }
            case .failure(let error):
                complition(.failure(error))
            }
        }
    }
    
    func getWaitingChatMassege(chat: Mchat, complition: @escaping (Result<[MMessage], Error>) -> Void) {
        let referance = waitingChatRef.document(chat.friendId).collection("massage")
        var massages = [MMessage]()
        referance.getDocuments { (querySnapshot, error) in
            if let error = error {
                complition(.failure(error))
                return
            }
            for document in querySnapshot!.documents {
                guard let massege = MMessage(document: document) else {return}
                massages.append(massege)
            }
            complition(.success(massages))
        }
    }
    
    func changeToActive(chat: Mchat, complition: @escaping (Result<Void, Error>) -> Void) {
        getWaitingChatMassege(chat: chat) { (result) in
            switch result {
            case .success(let masseges):
                self.deleteWaitingChats(chat: chat) { (result) in
                    switch result {
                    case .success:
                        self.createActiveChat(chat: chat, masseges: masseges) { (result) in
                            switch result {
                            case .success:
                                complition(.success(Void()))
                            case .failure(let error):
                                complition(.failure(error))
                            }
                        }
                    case .failure(let error):
                        complition(.failure(error))
                    }
                }
            case .failure(let error):
                complition(.failure(error))
            }
        }
    }
    
    func createActiveChat(chat: Mchat, masseges: [MMessage], complition: @escaping (Result<Void, Error>) -> Void) {
        let massegeRef = activeChatRef.document(chat.friendId).collection("massege")
        activeChatRef.document(chat.friendId).setData(chat.representation) { (error) in
            if let error = error {
                complition(.failure(error))
                return
            }
            
            for massege in masseges {
                massegeRef.addDocument(data: massege.representation) { (error) in
                    if let error = error {
                        complition(.failure(error))
                        return
                    }
                    complition(.success(Void()))
                }
            }
        }
    }
    
    func sendMessage(chat: Mchat, message: MMessage, complition: @escaping (Result<Void, Error>) -> Void) {
        
        let friendRef = usersRef.document(chat.friendId).collection("activeChats").document(currentUser.id)
        let friendMessageRef = friendRef.collection("massege")
        let myMessageRef = usersRef.document(currentUser.id).collection("activeChats").document(chat.friendId).collection("massage")
        
        let chatForFriend = Mchat(friendUsername: currentUser.username,
                                  friendavatarStringURL: currentUser.avatarStringURL,
                                  lastMessage: message.content,
                                  friendId: currentUser.id)
        friendRef.setData(chatForFriend.representation) { (error) in
            if let error = error {
                complition(.failure(error))
                return
            }
            friendMessageRef.addDocument(data: message.representation) { (error) in
                if let error = error {
                    complition(.failure(error))
                    return
                }
                myMessageRef.addDocument(data: message.representation) { (error) in
                    if let error = error {
                        complition(.failure(error))
                        return
                    }
                    complition(.success(Void()))
                }
            }
        }
    }
}
