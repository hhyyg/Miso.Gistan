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

    init(
        parentItemIdentifier: NSFileProviderItemIdentifier,
        gistItem: GistItem,
        gistFile: GistFile
        ) {
        self.parentItemIdentifier = parentItemIdentifier

        //TDOO: .をremoveせずエスケープへ
        self.itemIdentifier = NSFileProviderItemIdentifier("gists.\(gistItem.owner.login.urlEncoding()).\(gistItem.id).\(gistFile.filename.urlEncoding())")
        self.filename = gistFile.filename
    }

    var capabilities: NSFileProviderItemCapabilities {
        return .allowsAll
    }

    var typeIdentifier: String {
        //TODO:return typeIdentifier
        return "public.plain-text"
    }
}
