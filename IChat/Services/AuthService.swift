//
//  AuthService.swift
//  IChat
//
//  Created by kris on 30/09/2020.
//  Copyright © 2020 kris. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class AuthService {
    
    static let shered = AuthService()
    let auth = Auth.auth()
    
    func login(email: String?, password: String?, complition: @escaping (Result<User, Error>) -> Void) {
        
        guard let email = email,
            let password = password else {
                complition(.failure(AuthError.notFilled))
                return
        }
        
        auth.signIn(withEmail: email, password: password) { (result, error) in
            guard let result = result else {
                complition(.failure(error!))
                return
            }
            complition(.success(result.user))
        }
    }
    
    func googleLogIn(user: GIDGoogleUser!, error: Error!, complition: @escaping (Result<User, Error>) -> Void) {
        
        if let error = error {
            complition(.failure(error))
        } else {
            guard let auth = user.authentication else {return}
            let credential = GoogleAuthProvider.credential(withIDToken: auth.idToken,
                                                           accessToken: auth.accessToken)
            Auth.auth().signIn(with: credential) { (result, error) in
                guard let result = result else {
                    complition(.failure(error!))
                    return
                }
                complition(.success(result.user))
            }
        }
    }
    
    func register(email: String?, password: String?, confirmPassword: String?, complition: @escaping (Result<User, Error>) -> Void) {
        
        guard Validates.isField(email: email, password: password, confirmPassword: confirmPassword) else {
            complition(.failure(AuthError.notFilled))
            return
        }
        
        guard Validates.isValidEmail(email: email) else {
            complition(.failure(AuthError.invalidEmail))
            return
        }
        
        guard password?.lowercased() == confirmPassword?.lowercased() else {
            complition(.failure(AuthError.passwordDoNotMatch))
            return
        }
        
        auth.createUser(withEmail: email!, password: password!) { (result, error) in
            guard let result = result else {
                complition(.failure(error!))
                return
            }
            complition(.success(result.user))
        }
    }
}
