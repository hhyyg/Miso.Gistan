//
//  GistFileFileProviderItem.swift
//  Gistan
//
//  Created by Hiroka Yago on 2017/10/09.
//  Copyright © 2017 miso. All rights reserved.
//

import Foundation
import FileProvider

class GistFileFileProviderItem: NSObject, NSFileProviderItem {

    let parentItemIdentifier: NSFileProviderItemIdentifier
    let itemIdentifier: NSFileProviderItemIdentifier
    let filename: String

    init(
        parentItemIdentifier: NSFileProviderItemIdentifier,
        gistItem: GistItem,
        gistFile: GistFile
        ) {
        self.parentItemIdentifier = parentItemIdentifier

        self.itemIdentifier = NSFileProviderItemIdentifier("gists.\(gistItem.owner.login).\(gistItem.id).\(gistFile.filename)")
        self.filename = gistFile.filename
    }

    var capabilities: NSFileProviderItemCapabilities {
        return .allowsAll
    }

    var typeIdentifier: String {
        return "public.text"
    }
}
