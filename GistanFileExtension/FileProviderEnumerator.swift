//
//  FileProviderEnumerator.swift
//  GistanFileExtension
//
//  Created by Hiroka Yago on 2017/10/08.
//  Copyright © 2017 miso. All rights reserved.
//

import FileProvider

class GistItemFileProviderEnumerator: NSObject, NSFileProviderEnumerator {

    private let parentItem: GistItem
    private let parentItemIdentifier: NSFileProviderItemIdentifier

    init(
        parentItem: GistItem,
        parentItemIdentifier: NSFileProviderItemIdentifier) {
        self.parentItem = parentItem
        self.parentItemIdentifier = parentItemIdentifier

        super.init()
    }

    func enumerateItems(for observer: NSFileProviderEnumerationObserver, startingAt page: NSFileProviderPage) {
        let items: [NSFileProviderItemProtocol]
        items = parentItem.files.map {
            GistFileFileProviderItem(parentItemIdentifier: self.parentItemIdentifier,
                                     gistItem: self.parentItem,
                                     gistFile: $0.value)
        }
        observer.didEnumerate(items)
        observer.finishEnumerating(upTo: nil)
    }

    func invalidate() {
    }
}

class FileProviderEnumerator: NSObject, NSFileProviderEnumerator {

    func invalidate() {
    }

    func enumerateItems(
        for observer: NSFileProviderEnumerationObserver,
        startingAt page: NSFileProviderPage) {

        GistService.load {
            let providerItems = GistService.gistItems.map { return GistFileProviderItem(item: $0) }
            observer.didEnumerate(providerItems)
            observer.finishEnumerating(upTo: nil)
        }
    }

    func enumerateChanges(for observer: NSFileProviderChangeObserver, from anchor: NSFileProviderSyncAnchor) {
        /* TODO:
         - query the server for updates since the passed-in sync anchor
         
         If this is an enumerator for the active set:
         - note the changes in your local database
         
         - inform the observer about item deletions and updates (modifications + insertions)
         - inform the observer when you have finished enumerating up to a subsequent sync anchor
         */
    }

}
