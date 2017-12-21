//
//  AccountViewController.swift
//  Gistan
//
//  Created by Hiroka Yago on 2017/10/03.
//  Copyright © 2017 miso. All rights reserved.
//

import UIKit
import OAuthSwift
import KeychainAccess
import SafariServices
import RxSwift

class AccountViewController: UIViewController {

    weak var delegate: AccountViewControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func authorizeGitHub(_ sender: Any) {

        let githubAuth = GitHubAuthentication()
        githubAuth.authorize(
            success: { credential, _, _ in
                logger.debug("get token: \(credential.oauthToken)")
                KeychainService.set(forKey: .oauthToken, value: credential.oauthToken)
                self.getLoginUser()
            },
            failure: { error in
                logger.error(error.localizedDescription)
                assertionFailure()
            }
        )

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getLoginUser() {
        let client = GitHubClient()
        let request = GitHubAPI.GetMe()

        _ = client.send(request: request)
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { userInfo in
                    //user名を保存
                    KeychainService.set(forKey: .userName, value: userInfo.login)

                    self.delegate.accountViewControllerDidDismiss(accountViewController: self)
                    self.dismiss(animated: true, completion: nil)
            },
                onError: { error in
                    logger.error("not found(error: \(error)")
                    assertionFailure()
            })
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

}

protocol AccountViewControllerDelegate: class {
    func accountViewControllerDidDismiss(accountViewController: AccountViewController)
}
