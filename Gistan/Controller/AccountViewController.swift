//
//  AccountViewController.swift
//  Gistan
//
//  Created by Hiroka Yago on 2017/10/03.
//  Copyright © 2017 miso. All rights reserved.
//

import UIKit
import OAuthSwift

class AccountViewController: UIViewController {

    @IBOutlet weak private var userNameTextField: UITextField!
    weak var delegate: AccountViewControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

        userNameTextField!.delegate = self
        userNameTextField!.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }

    @IBAction func authorizeGitHub(_ sender: Any) {

        // create an instance and retain it
        let oauthswift = OAuth2Swift(
            consumerKey:    SettingsContainer.settings.githubClientId,
            consumerSecret: SettingsContainer.settings.githubSecretKey,
            authorizeUrl: "https://github.com/login/oauth/authorize",
            accessTokenUrl: "https://github.com/login/oauth/access_token",
            responseType: "token",
            contentType: "application/json"
        )

        oauthswift.authorizeURLHandler = SafariURLHandler(viewController: self, oauthSwift: oauthswift)

        oauthswift.authorize(
            withCallbackURL: URL(string: "gistan://oauth-callback")!,
            scope: "public", state:"me",
            success: { credential, _, _ in
                logger.debug(credential.oauthToken)

            },
            failure: { error in
                logger.error(error.localizedDescription)
            }
        )

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func existUser(userName: String) {
        let client = GitHubClient()
        let request = GitHubAPI.GetUser(userName: userName)

        client.send(request: request) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.delegate.accountViewControllerDidDismiss(accountViewController: self, userName: userName)
                    self.dismiss(animated: true, completion: nil)
                }
            case let .failure(error):
                //TODO: 見つからない場合
                logger.error("not found(error: \(error)")
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
        logger.debug("viewWillDisappear")
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
    func accountViewControllerDidDismiss(accountViewController: AccountViewController, userName: String)
}

extension AccountViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let userName = userNameTextField!.text, !userName.isEmpty else {
            //TODO:入力してほしい感じ
            return false
        }
        existUser(userName: userName)
        return false
    }
}
