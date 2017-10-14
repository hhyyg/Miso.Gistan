//
//  GistFileFileProviderItem.swift
//  Gistan
//
//  Created by Hiroka Yago on 2017/10/09.
//  Copyright © 2017 miso. All rights reserved.
//

import Foundation
import FileProvider

//TODO: identifierDelimiter = "."

class GistFileFileProviderItem: NSObject, NSFileProviderItem {

    let parentItemIdentifier: NSFileProviderItemIdentifier
    let itemIdentifier: NSFileProviderItemIdentifier
    let filename: String
    let typeIdentifier: String

    init(
        parentItemIdentifier: NSFileProviderItemIdentifier,
        gistItem: GistItem,
        gistFile: GistFile
        ) {
        self.parentItemIdentifier = parentItemIdentifier
        self.itemIdentifier = NSFileProviderItemIdentifier("gists.\(gistItem.owner.login.urlEncoding()).\(gistItem.id).\(gistFile.filename.urlEncoding())")
        self.filename = gistFile.filename

        if gistFile.type.starts(with: "text/") {
            self.typeIdentifier = "public.plain-text"
        } else {
            self.typeIdentifier = "public.item"
        }
    }

    var capabilities: NSFileProviderItemCapabilities {
        return .allowsAll
    }
}
