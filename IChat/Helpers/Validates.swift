//
//  Validates.swift
//  IChat
//
//  Created by kris on 30/09/2020.
//  Copyright © 2020 kris. All rights reserved.
//

import Foundation

class Validates {
    
    static func isField(email: String?, password: String?, confirmPassword: String?) -> Bool {
        guard let email = email,
            let password = password,
            let confirmPassword = confirmPassword,
            email != "",
            password != "",
            confirmPassword != "" else {
                return false
        }
        return true
    }
    
    static func isField(username: String?, description: String?, sex: String?) -> Bool {
        guard let username = username,
            let description = description,
            let sex = sex,
            username != "",
            description != "",
            sex != "" else {
                return false
        }
        return true
    }
    
    static func isValidEmail(email: String?) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
