//
//  GistService.swift
//  GistanFileExtension
//
//  Created by Hiroka Yago on 2017/10/10.
//  Copyright © 2017 miso. All rights reserved.
//

import Foundation
import RxSwift

class GistService {

    static var gistItems: [GistItem] = []

    static func load(onSuccess: @escaping () -> Void ) {
        let userName = KeychainService.get(forKey: .userName)!

        let client = GitHubClient()
        let request = GitHubAPI.GetUsersGists(userName: userName)

        _ = client.send(request: request)
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { response in
                    self.gistItems = response
                    onSuccess()
            },
                onError: { error in
                    assertionFailure()
            })
    }

    static func getData(
        url: URL,
        completion: @escaping (Data) -> Void ) {

        let client = GitHubClient()
        _ = client.getData(url: url) { data in
            completion(data)
        }
    }
}
