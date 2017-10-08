//
//  FileProviderItem.swift
//  GistanFileExtension
//
//  Created by Hiroka Yago on 2017/10/08.
//  Copyright © 2017 miso. All rights reserved.
//

import FileProvider

class FileProviderItem: NSObject, NSFileProviderItem {

    // TODO: implement an initializer to create an item from your extension's backing model
    // TODO: implement the accessors to return the values from your extension's backing model

    var itemIdentifier: NSFileProviderItemIdentifier {
        return NSFileProviderItemIdentifier("")
    }

    var parentItemIdentifier: NSFileProviderItemIdentifier {
        return NSFileProviderItemIdentifier("")
    }

    var capabilities: NSFileProviderItemCapabilities {
        return .allowsAll
    }

    var filename: String {
        return ""
    }

    var typeIdentifier: String {
        return ""
    }

}
