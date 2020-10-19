//
//  NavigationChatProtocol.swift
//  IChat
//
//  Created by kris on 04/10/2020.
//  Copyright © 2020 kris. All rights reserved.
//

import Foundation

protocol NavigationChatProtocol: class {
    func removeWaitingChat(chat: Mchat)
    func changeToActive(chat: Mchat)
}
