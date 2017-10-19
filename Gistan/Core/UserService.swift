//
//  UserService.swift
//  Gistan
//
//  Created by Hiroka Yago on 2017/10/07.
//  Copyright © 2017 miso. All rights reserved.
//

import Foundation

class UserService {

    static func loggedIn() -> Bool {
        if
            let token = KeychainService.get(forKey: .oauthToken),
            let userName = KeychainService.get(forKey: .userName),
            !token.isEmpty,
            !userName.isEmpty {
            return true
        }
        return false
    }
}
