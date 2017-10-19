//
//  GitHubAuthentication.swift
//  Gistan
//
//  Created by Hiroka Yago on 2017/10/07.
//  Copyright © 2017 miso. All rights reserved.
//

import Foundation
import SafariServices
import OAuthSwift

class AuthenticationSession: OAuthSwiftURLHandlerType {
    private var session: SFAuthenticationSession?
    private let cancel: () -> Void
    init(cancel: @escaping () -> Void) {
        self.cancel = cancel
    }

    func handle(_ url: URL) {
        self.session = SFAuthenticationSession(url: url, callbackURLScheme: nil) {  (url, _) in
            guard let url = url else {
                self.cancel()
                return
            }
            OAuth2Swift.handle(url: url)
        }
        session?.start()
    }
}

class GitHubAuthentication {
    private let oauthSwift: OAuth2Swift

    init() {
        oauthSwift = OAuth2Swift(
            consumerKey:    SettingsContainer.settings.githubClientId,
            consumerSecret: SettingsContainer.settings.githubSecretKey,
            authorizeUrl: "https://github.com/login/oauth/authorize",
            accessTokenUrl: "https://github.com/login/oauth/access_token",
            responseType: "token",
            contentType: "application/json"
        )
        oauthSwift.authorizeURLHandler = AuthenticationSession {
            self.oauthSwift.cancel()
        }
    }

    func authorize(
        success: @escaping OAuthSwift.TokenSuccessHandler,
        failure: OAuthSwift.FailureHandler?) {

        self.oauthSwift.authorize(
            withCallbackURL: URL(string: "gistan://oauth-callback")!,
            scope: "public",
            state:"me",
            success: success,
            failure: failure
        )
    }
}
