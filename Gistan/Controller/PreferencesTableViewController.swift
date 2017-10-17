//
//  PreferencesTableViewController.swift
//  Gistan
//
//  Created by Hiroka Yago on 2017/10/17.
//  Copyright © 2017 miso. All rights reserved.
//

import UIKit
import SafariServices

class PreferencesTableViewController: UITableViewController {

    enum Row: Int {
        case
        logOut,
        github
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController!.navigationBar.prefersLargeTitles = true
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch Row(rawValue: indexPath.row)! {
        case .logOut:
            logOut()
        case .github:
            goGitHub()
        }
    }

    func goGitHub() {
        let safariViewController = SFSafariViewController(url: URL(string: "https://github.com/")!) //TODO:GitHub Repository
        self.showDetailViewController(safariViewController, sender: nil)
    }

    func logOut() {
        KeychainService.set(forKey: .oauthToken, value: "")
        KeychainService.set(forKey: .userName, value: "")

        goAccountViewController(modalTransitionStyle: .coverVertical)
    }

    func goAccountViewController(modalTransitionStyle: UIModalTransitionStyle) {
        let accountVC = self.storyboard!.instantiateViewController(withIdentifier: "AccountPage") as! AccountViewController
        accountVC.delegate = (self.tabBarController!.viewControllers![0] as! UINavigationController).viewControllers[0] as! MyGistsTableViewController
        accountVC.modalTransitionStyle = modalTransitionStyle
        present(accountVC, animated: true, completion: nil)

        self.tabBarController!.selectedIndex = 0
    }

}
