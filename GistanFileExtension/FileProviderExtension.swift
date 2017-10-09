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
    private var gistItems: [GistItem] = []

    override init() {
        super.init()

        let token: String? = KeychainService.get(forKey: .oauthToken)
        logger.debug(token ?? "token is null")

        //TODO: if token is null
        if token != nil {
            self.load()
        }
        //TODO: no sleep
        Thread.sleep(forTimeInterval: 1)
    }

    func load() {
        let userName = KeychainService.get(forKey: .userName)!

        let client = GitHubClient()
        let request = GitHubAPI.GetUsersGists(userName: userName)

        client.send(request: request) { result in
            switch result {
            case let .success(response):
                self.gistItems = response
            case .failure(_):
                assertionFailure()
            }
        }
    }

    func item(for identifier: NSFileProviderItemIdentifier) throws -> NSFileProviderItem? {
        // resolve the given identifier to a record in the model

        // TODO: implement the actual lookup
        return FileProviderItem(identifier: identifier)
    }

    override func urlForItem(withPersistentIdentifier identifier: NSFileProviderItemIdentifier) -> URL? {
        logger.debug("urlForItem: \(identifier.rawValue)")

        // resolve the given identifier to a file on disk
        guard let item = try? item(for: identifier) else {
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
    }

    override func startProvidingItem(at url: URL, completionHandler: ((_ error: Error?) -> Void)?) {
        // Should ensure that the actual file is in the position returned by URLForItemWithIdentifier:, then call the completion handler

        /* TODO:
         This is one of the main entry points of the file provider. We need to check whether the file already exists on disk,
         whether we know of a more recent version of the file, and implement a policy for these cases. Pseudocode:
         
         if !fileOnDisk {
             downloadRemoteFile()
             callCompletion(downloadErrorOrNil)
         } else if fileIsCurrent {
             callCompletion(nil)
         } else {
             if localFileHasChanges {
                 // in this case, a version of the file is on disk, but we know of a more recent version
                 // we need to implement a strategy to resolve this conflict
                 moveLocalFileAside()
                 scheduleUploadOfLocalFile()
                 downloadRemoteFile()
                 callCompletion(downloadErrorOrNil)
             } else {
                 downloadRemoteFile()
                 callCompletion(downloadErrorOrNil)
             }
         }
         */

        completionHandler?(NSError(domain: NSCocoaErrorDomain, code: NSFeatureUnsupportedError, userInfo:[:]))
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
            // instantiate an enumerator for the container root
            logger.debug("item length is\(gistItems.count)")
            return FileProviderSerivce.getRootFileProviderEnumerator(items: self.gistItems)

        } else if (containerItemIdentifier == NSFileProviderItemIdentifier.workingSet) {
            // TODO: instantiate an enumerator for the working set
            logger.debug("workingSet")
        } else {
            logger.debug("item for directory")
            // TODO: determine if the item is a directory or a file
            // - for a directory, instantiate an enumerator of its subitems
            // - for a file, instantiate an enumerator that observes changes to the file
            return FileProviderSerivce.getChildlen(items: self.gistItems, identifier: containerItemIdentifier)
        }
        guard let enumerator = maybeEnumerator else {
            throw NSError(domain: NSCocoaErrorDomain, code: NSFeatureUnsupportedError, userInfo:[:])
        }
        return enumerator
    }

}

class FileProviderSerivce {

    static func getRootFileProviderEnumerator(items: [GistItem]) -> NSFileProviderEnumerator {
        let providerItems = items.map { return GistFileProviderItem(item: $0) }
        return FileProviderEnumerator(items: providerItems)
    }

    static func getChildlen(items: [GistItem], identifier: NSFileProviderItemIdentifier) -> NSFileProviderEnumerator {
        let gistItem = getGistItem(items: items, identifier: identifier)
        return GistItemFileProviderEnumerator(parentItem: gistItem, parentItemIdentifier: identifier)
    }

    static func getGistItem(items: [GistItem], identifier: NSFileProviderItemIdentifier) -> GistItem {
        let identifierComponents = identifier.rawValue.components(separatedBy: ".")
        let gistId = identifierComponents.last!
        let foundItem = items.filter { return $0.id == gistId }.first!
        return foundItem
    }

}
