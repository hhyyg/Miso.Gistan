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

        client.send(request: request) { result in
            switch result {
            case let .success(userInfo):
                //user名を保存
                UserDefaults.standard.set(userInfo.login, forKey: UserDefaultKey.userName.rawValue)

                DispatchQueue.main.async {
                    self.delegate.accountViewControllerDidDismiss(accountViewController: self)
                    self.dismiss(animated: true, completion: nil)
                }
            case let .failure(error):
                //TODO: 見つからない場合
                logger.error("not found(error: \(error)")
                assertionFailure()
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

protocol AccountViewControllerDelegate: class {
    func accountViewControllerDidDismiss(accountViewController: AccountViewController)
}
