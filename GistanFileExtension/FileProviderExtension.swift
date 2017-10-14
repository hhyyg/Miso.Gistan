//
//  FileProviderExtension.swift
//  GistanFileExtension
//
//  Created by Hiroka Yago on 2017/10/08.
//  Copyright © 2017 miso. All rights reserved.
//

import FileProvider
import Foundation

class FileProviderExtension: NSFileProviderExtension {

    private var fileManager = FileManager()

    override init() {
        super.init()

        let token: String? = KeychainService.get(forKey: .oauthToken)
        logger.debug(token ?? "token is null")

        //TODO: if token is null
        if token == nil {
            assertionFailure()
        }
    }

    private func getItem(for identifier: NSFileProviderItemIdentifier) throws -> NSFileProviderItem {
        let type = FileProviderSerivce.getIdentifierType(identifier: identifier)
        switch type {
        case .root:
            fatalError()
        case .gistItem:
            let item = FileProviderSerivce.getGistItem(identifier: identifier)
            return GistFileProviderItem(item: item)
        case .gistFile:
            let parentIdentifier = FileProviderSerivce.getParentIdentifier(identifier: identifier)
            let parentGistItem = FileProviderSerivce.getGistItem(identifier: parentIdentifier)
            let gistFile = FileProviderSerivce.getGileFile(gistFileIdentifier: identifier)!

            return GistFileFileProviderItem(parentItemIdentifier: parentIdentifier, gistItem: parentGistItem, gistFile: gistFile)
        }
    }

    override func urlForItem(withPersistentIdentifier identifier: NSFileProviderItemIdentifier) -> URL? {
        //logger.debug("urlForItem: \(identifier.rawValue)")

        if (identifier == NSFileProviderItemIdentifier.rootContainer) {
            return nil
        }
        // resolve the given identifier to a file on disk
        guard let item = try? getItem(for: identifier) else {
            return nil
        }

        // in this implementation, all paths are structured as <base storage directory>/<item identifier>/<item file name>
        let manager = NSFileProviderManager.default
        let perItemDirectory = manager.documentStorageURL.appendingPathComponent(identifier.rawValue, isDirectory: true)

        return perItemDirectory.appendingPathComponent(item.filename, isDirectory:false)
    }

    override func persistentIdentifierForItem(at url: URL) -> NSFileProviderItemIdentifier? {
        // resolve the given URL to a persistent identifier using a database
        let pathComponents = url.pathComponents

        // exploit the fact that the path structure has been defined as
        // <base storage directory>/<item identifier>/<item file name> above
        assert(pathComponents.count > 2)

        return NSFileProviderItemIdentifier(pathComponents[pathComponents.count - 2])
    }

    override func providePlaceholder(at url: URL, completionHandler: @escaping (Error?) -> Void) {
        logger.debug(url)

        do {
            try fileManager.createDirectory(at: url.deletingLastPathComponent(),
                                            withIntermediateDirectories: true,
                                            attributes: nil)
            fileManager.createFile(atPath: url.path, contents: nil, attributes: nil)
            completionHandler(nil)
        } catch let e {
            completionHandler(e)
        }
    }

    override func startProvidingItem(at url: URL, completionHandler: ((_ error: Error?) -> Void)?) {
        logger.debug(url)

        guard let identifier = persistentIdentifierForItem(at: url),
        let gistFile = FileProviderSerivce.getGileFile(gistFileIdentifier: identifier) else {
            completionHandler?(NSError(domain: NSCocoaErrorDomain, code: NSFeatureUnsupportedError, userInfo:[:]))
            return
        }
        GistService.getData(url: URL(string: gistFile.rawUrl)!) { data in
            do {
                try data.write(to: url)
                completionHandler?(nil)
            } catch let e {
                completionHandler?(e)
            }
        }
    }

    override func itemChanged(at url: URL) {
        // Called at some point after the file has changed; the provider may then trigger an upload

        /* TODO:
         - mark file at <url> as needing an update in the model
         - if there are existing NSURLSessionTasks uploading this file, cancel them
         - create a fresh background NSURLSessionTask and schedule it to upload the current modifications
         - register the NSURLSessionTask with NSFileProviderManager to provide progress updates
         */
    }

    override func stopProvidingItem(at url: URL) {
        // Called after the last claim to the file has been released. At this point, it is safe for the file provider to remove the content file.
        // Care should be taken that the corresponding placeholder file stays behind after the content file has been deleted.

        // Called after the last claim to the file has been released. At this point, it is safe for the file provider to remove the content file.

        // TODO: look up whether the file has local changes
        let fileHasLocalChanges = false

        if !fileHasLocalChanges {
            // remove the existing file to free up space
            do {
                _ = try FileManager.default.removeItem(at: url)
            } catch {
                // Handle error
            }

            // write out a placeholder to facilitate future property lookups
            self.providePlaceholder(at: url, completionHandler: { _ in
                // TODO: handle any error, do any necessary cleanup
            })
        }
    }

    // MARK: - Actions

    /* TODO: implement the actions for items here
     each of the actions follows the same pattern:
     - make a note of the change in the local model
     - schedule a server request as a background task to inform the server of the change
     - call the completion block with the modified item in its post-modification state
     */

    // MARK: - Enumeration

    override func enumerator(for containerItemIdentifier: NSFileProviderItemIdentifier) throws -> NSFileProviderEnumerator {
        let maybeEnumerator: NSFileProviderEnumerator? = nil

        if (containerItemIdentifier == NSFileProviderItemIdentifier.rootContainer) {
            return FileProviderEnumerator()
        } else if (containerItemIdentifier == NSFileProviderItemIdentifier.workingSet) {
            logger.debug("workingSet")
        } else {
            logger.debug("item for directory")
            // TODO: determine if the item is a directory or a file
            // - for a directory, instantiate an enumerator of its subitems
            // - for a file, instantiate an enumerator that observes changes to the file
            return FileProviderSerivce.getChildlenEnumerator(identifier: containerItemIdentifier)
        }
        guard let enumerator = maybeEnumerator else {
            throw NSError(domain: NSCocoaErrorDomain, code: NSFeatureUnsupportedError, userInfo:[:])
        }
        return enumerator
    }

}
