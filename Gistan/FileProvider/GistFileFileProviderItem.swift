//
//  GistFileFileProviderItem.swift
//  Gistan
//
//  Created by Hiroka Yago on 2017/10/09.
//  Copyright © 2017 miso. All rights reserved.
//

import Foundation
import FileProvider
import UTIKit

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
        self.filename = "\(gistFile.filename).show-extension"

        let uti = UTI(mimeType: gistFile.type)
        self.typeIdentifier = uti?.utiString ?? "public.item"
    }

    var capabilities: NSFileProviderItemCapabilities {
        return .allowsAll
    }
}
