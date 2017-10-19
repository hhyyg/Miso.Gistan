//
//  Config.swift
//  Gistan
//
//  Created by Hiroka Yago on 2017/10/04.
//  Copyright © 2017 miso. All rights reserved.
//
import Foundation

struct Settings: Codable {
    var githubClientId: String
    var githubSecretKey: String
}

final class SettingsContainer: NSObject {
    static var settings: Settings!
}
