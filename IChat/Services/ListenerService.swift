//
//  ListenerService.swift
//  IChat
//
//  Created by kris on 02/10/2020.
//  Copyright © 2020 kris. All rights reserved.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore

class ListenerService {
    
    static let shered = ListenerService()
    
    private var db = Firestore.firestore()
    
    private var userRef: CollectionReference {
        return db.collection("users")
    }
    
    private var currentUserUID: String {
        return Auth.auth().currentUser!.uid
    }
    
    func usersObserv(users: [MUser], complition: @escaping (Result<[MUser], Error>) -> Void) -> ListenerRegistration {
        
        var users = users
        let userListener = userRef.addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                complition(.failure(error!))
                return
            }
            snapshot.documentChanges.forEach { (diff) in
                guard let muser = MUser(document: diff.document) else {return}
                switch diff.type {
                    
                case .added:
                    guard !users.contains(muser) else {return}
                    guard muser.id != self.currentUserUID else {return}
                    users.append(muser)
                case .modified:
                    guard let index = users.firstIndex(of: muser) else {return}
                    users[index] = muser
                case .removed:
                    guard let index = users.firstIndex(of: muser) else {return}
                    users.remove(at: index)
                }
            }
            complition(.success(users))
        }
        return userListener
    }
    
    func waitingChatsObserv(chats: [Mchat], complition: @escaping (Result<[Mchat], Error>) -> Void) -> ListenerRegistration? {
    
        var chats = chats
        let chatRef = db.collection(["users", currentUserUID, "waitingChats"].joined(separator: "/"))
        let waitingChatsListener = chatRef.addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                complition(.failure(error!))
                return
            }
            snapshot.documentChanges.forEach { (diff) in
                guard let chat = Mchat(document: diff.document) else {return}
                     switch diff.type {
                           case .added:
                               guard !chats.contains(chat) else {return}
                               chats.append(chat)
                           case .modified:
                               guard let index = chats.firstIndex(of: chat) else {return}
                               chats[index] = chat
                           case .removed:
                               guard let index = chats.firstIndex(of: chat) else {return}
                               chats.remove(at: index)
                           }
            }
            complition(.success(chats))
        }
        return waitingChatsListener
    }
    
    func activeChatsObserv(chats: [Mchat], complition: @escaping (Result<[Mchat], Error>) -> Void) -> ListenerRegistration? {
       
           var chats = chats
           let chatRef = db.collection(["users", currentUserUID, "activeChats"].joined(separator: "/"))
           let waitingChatsListener = chatRef.addSnapshotListener { (querySnapshot, error) in
               guard let snapshot = querySnapshot else {
                   complition(.failure(error!))
                   return
               }
               snapshot.documentChanges.forEach { (diff) in
                   guard let chat = Mchat(document: diff.document) else {return}
                        switch diff.type {
                              case .added:
                                  guard !chats.contains(chat) else {return}
                                  chats.append(chat)
                              case .modified:
                                  guard let index = chats.firstIndex(of: chat) else {return}
                                  chats[index] = chat
                              case .removed:
                                  guard let index = chats.firstIndex(of: chat) else {return}
                                  chats.remove(at: index)
                              }
               }
               complition(.success(chats))
           }
           return waitingChatsListener
       }
    
    func messageObserv(chat: Mchat, complition: @escaping (Result<MMessage, Error>) -> Void) -> ListenerRegistration? {
        
        let ref = userRef.document(currentUserUID).collection("activeChats").document(chat.friendId).collection("massege")
        let messageListener = ref.addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                complition(.failure(error!))
                return
            }
            snapshot.documentChanges.forEach { (diff) in
                guard let message = MMessage(document: diff.document) else {return}
                switch diff.type {
                case .added:
                    complition(.success(message))
                    print(1)
                case .modified:
                    break
                case .removed:
                    break
                }
            }
        }
        return messageListener
    }
}
