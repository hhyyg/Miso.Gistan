//
//  GistFileProviderItem.swift
//  Gistan
//
//  Created by Hiroka Yago on 2017/10/09.
//  Copyright © 2017 miso. All rights reserved.
//

import Foundation
import FileProvider

class GistFileProviderItem: NSObject, NSFileProviderItem {
    private let gistId: String
    private let gistName: String
    private let ownerName: String

    init(item: GistItem) {
        self.gistId = item.id
        self.gistName = item.getFirstFileName()
        self.ownerName = item.owner.login.removing(".")
    }

    var itemIdentifier: NSFileProviderItemIdentifier {
        return NSFileProviderItemIdentifier("gists.\(self.ownerName).\(self.gistId)")
    }

    var parentItemIdentifier: NSFileProviderItemIdentifier {
        return NSFileProviderItemIdentifier.rootContainer
    }

    var capabilities: NSFileProviderItemCapabilities {
        return .allowsAll
    }

    var filename: String {
        return "\(self.ownerName)/\(self.gistName)"
    }

    var typeIdentifier: String {
        return "public.folder"
    }
}
