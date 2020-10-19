//
//  UserError.swift
//  IChat
//
//  Created by kris on 01/10/2020.
//  Copyright © 2020 kris. All rights reserved.
//

import Foundation

enum UserError {
    case notFilled
    case avatarNotExist
    case canNotExistUserInfo
    case canNotUnwrapToUser

}

extension UserError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Заполните все поля", comment: "")
        case .avatarNotExist:
            return NSLocalizedString("Не выбрана фотография", comment: "")
        case .canNotExistUserInfo:
            return NSLocalizedString("Невозможно загрузить информацию по User", comment: "")
        case .canNotUnwrapToUser:
            return NSLocalizedString("Невозможно конвертировать MUser в User", comment: "")
        }
    }
}
