//
//  GitHubAPI.swift
//  Gistan
//
//  Created by Hiroka Yago on 2017/10/01.
//  Copyright © 2017 miso. All rights reserved.
//

final class GitHubAPI {
    struct GetUsersGists: GitHubRequest {
        typealias Response = [GistItem]

        let userName: String

        var method: HTTPMethod {
            return .get
        }

        var path: String {
            return "users/\(userName)/gists"
        }

        var parameters: Any? {
            return nil
        }
    }
}
