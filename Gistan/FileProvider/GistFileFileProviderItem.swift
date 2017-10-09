//
//  GistFileFileProviderItem.swift
//  Gistan
//
//  Created by Hiroka Yago on 2017/10/09.
//  Copyright © 2017 miso. All rights reserved.
//

import Foundation
import FileProvider

// TODO: 移動, リネーム
let delimiter = "."

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
        self.itemIdentifier = NSFileProviderItemIdentifier("gists.\(gistItem.owner.login.removing(".")).\(gistItem.id).\(gistFile.filename.removing("."))")
        self.filename = gistFile.filename
    }

    var capabilities: NSFileProviderItemCapabilities {
        return .allowsAll
    }

    var typeIdentifier: String {
        return "public.text"
    }
}
