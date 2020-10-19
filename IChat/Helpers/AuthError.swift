//
//  AuthError.swift
//  IChat
//
//  Created by kris on 30/09/2020.
//  Copyright © 2020 kris. All rights reserved.
//

import Foundation

enum AuthError {
    case notFilled
    case invalidEmail
    case passwordDoNotMatch
    case unKnownError
    case serviceError
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        
        case .notFilled:
            return NSLocalizedString("Заполните все поля", comment: "")
        case .invalidEmail:
            return NSLocalizedString("Формат Email не допустим", comment: "")
        case .passwordDoNotMatch:
            return NSLocalizedString("Пароли не совпадают", comment: "")
        case .unKnownError:
            return NSLocalizedString("Неизвестная ошибка", comment: "")
        case .serviceError:
            return NSLocalizedString("Ошибка на сервере", comment: "")
        }
    }
}


