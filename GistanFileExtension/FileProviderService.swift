//
//  FileProviderService.swift
//  GistanFileExtension
//
//  Created by Hiroka Yago on 2017/10/14.
//  Copyright © 2017 miso. All rights reserved.
//
import FileProvider

class FileProviderSerivce {

    static func getChildlenEnumerator(identifier: NSFileProviderItemIdentifier) -> NSFileProviderEnumerator {
        let gistItem = getGistItem(identifier: identifier)
        return GistItemFileProviderEnumerator(parentItem: gistItem, parentItemIdentifier: identifier)
    }

    //GistItemのIdentifierからGistItemを返す（TODO:identifierがItem限定）
    static func getGistItem(identifier: NSFileProviderItemIdentifier) -> GistItem {
        let identifierComponents = identifier.rawValue.components(separatedBy: ".")
        let gistId = identifierComponents.last!
        let foundItem = GistService.gistItems.filter { return $0.id == gistId }.first!
        return foundItem
    }

    //identifierから、その親のIdentifierを取得する
    static func getParentIdentifier(identifier: NSFileProviderItemIdentifier) ->
        NSFileProviderItemIdentifier {
            let identifierRaw = identifier.rawValue
            var components = identifierRaw.components(separatedBy: ".")
            assert(components.count == 4)
            components.removeLast()
            let parentIdentifierRaw = components.joined(separator: ".")
            return NSFileProviderItemIdentifier(parentIdentifierRaw)
    }

    static func getGileFile(gistFileIdentifier: NSFileProviderItemIdentifier) -> GistFile? {
        let parentIdentifier = FileProviderSerivce.getParentIdentifier(identifier: gistFileIdentifier)
        let parentGistItem = FileProviderSerivce.getGistItem(identifier: parentIdentifier)

        let fileNameEncoded = gistFileIdentifier.rawValue.components(separatedBy: ".").last!.urlDecoding()
        let gistFile = parentGistItem.files.filter { key, _ in
            return key == fileNameEncoded
            }.first?.value
        return gistFile
    }

    //identifiierから、それがGistItemかGistFileかを返す
    static func getIdentifierType(identifier: NSFileProviderItemIdentifier) -> IdentifierType {

        if identifier == NSFileProviderItemIdentifier.rootContainer {
            return .root
        }

        switch identifier.rawValue.components(separatedBy: ".").count {
        case 3:
            return .gistItem
        case 4:
            return .gistFile
        default:
            fatalError("invalid")
        }
    }
}
