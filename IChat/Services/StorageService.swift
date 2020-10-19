//
//  StorageService.swift
//  IChat
//
//  Created by kris on 02/10/2020.
//  Copyright © 2020 kris. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class StorageService {
    
    static let shered = StorageService()
    
    let storageRef = Storage.storage().reference()
    
    private var avatarRef: StorageReference {
        return storageRef.child("avatars")
    }
    
    private var currentUserID: String {
        return Auth.auth().currentUser!.uid
    }
    
    func upload(photo: UIImage, complition: @escaping (Result<URL, Error>) -> Void) {
        
        guard let scaleImage = photo.scaledToSafeUploadSize, let imageData = scaleImage.jpegData(compressionQuality: 0.4) else {return}
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        avatarRef.child(currentUserID).putData(imageData, metadata: metadata) { (metadata, error) in
            guard let _ = metadata else {
                complition(.failure(error!))
                return
            }
            self.avatarRef.child(self.currentUserID).downloadURL { (url, error) in
                guard let downloadURL = url else {
                    complition(.failure(error!))
                    return
                }
                complition(.success(downloadURL))
            }
        }
    }
    
   
}
