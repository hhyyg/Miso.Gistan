//
//  GistService.swift
//  GistanFileExtension
//
//  Created by Hiroka Yago on 2017/10/10.
//  Copyright © 2017 miso. All rights reserved.
//

import Foundation

class GistService {

    static var gistItems: [GistItem] = []

    static func load(onSuccess: @escaping () -> Void ) {
        let userName = KeychainService.get(forKey: .userName)!

        let client = GitHubClient()
        let request = GitHubAPI.GetUsersGists(userName: userName)

        client.send(request: request) { result in
            switch result {
                case let .success(response):
                    self.gistItems = response
                    onSuccess()
                case .failure(_):
                    assertionFailure()
            }
        }
    }
}
