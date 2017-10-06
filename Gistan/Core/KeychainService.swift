//
//  KeychainService.swift
//  Gistan
//
//  Created by Hiroka Yago on 2017/10/06.
//  Copyright © 2017 miso. All rights reserved.
//

import Foundation
import KeychainAccess

class KeychainService {
    enum Key: String {
        case oauthToken = "oauthtoken"
    }

    private static var keychain = Keychain(service: Bundle.main.bundleIdentifier!)

    static func GetKeychain(key: Key) -> String? {
        let value = keychain[key.rawValue]
        return value
    }

    static func SetKeychain(key: Key, value: String) {
        keychain[key.rawValue] = value
    }
}
