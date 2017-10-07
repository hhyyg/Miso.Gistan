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
        case oauthToken
    }

    private static var keychain = Keychain(service: Bundle.main.bundleIdentifier!)

    static func get(forKey key: Key) -> String? {
        return keychain[key.rawValue]
    }

    static func set(forKey key: Key, value: String) {
        keychain[key.rawValue] = value
    }
}
