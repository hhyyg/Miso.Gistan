//
//  GitHubAPI.swift
//  Gistan
//
//  Created by Hiroka Yago on 2017/10/01.
//  Copyright © 2017 miso. All rights reserved.
//

final class GitHubAPI {
    /// Userのgistを取得
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

    /// Userのフォローしている人を取得
    struct GetUsersFollowing: GitHubRequest {
        typealias Response = [User]

        let userName: String

        var method: HTTPMethod {
            return .get
        }

        var path: String {
            return "users/\(userName)/following"
        }

        var parameters: Any? {
            return nil
        }
    }

    /// get user info
    struct GetUser: GitHubRequest {
        typealias Response = User

        let userName: String

        var method: HTTPMethod {
            return .get
        }

        var path: String {
            return "users/\(userName)"
        }

        var parameters: Any? {
            return nil
        }
    }

    struct GetMe: GitHubRequest {
        typealias Response = User

        var method: HTTPMethod {
            return .get
        }

        var path: String {
            return "user"
        }

        var parameters: Any? {
            return nil
        }
    }

}
