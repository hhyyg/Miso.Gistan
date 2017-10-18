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
        logout
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController!.navigationBar.prefersLargeTitles = true
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch Row(rawValue: indexPath.row)! {
        case .logout:
            logout()
        }
    }

    func logout() {
        KeychainService.set(forKey: .oauthToken, value: "")
        KeychainService.set(forKey: .userName, value: "")

        goAccountViewController(modalTransitionStyle: .coverVertical)
        //TODO:followings reset
    }

    func goAccountViewController(modalTransitionStyle: UIModalTransitionStyle) {
        let accountVC = self.storyboard!.instantiateViewController(withIdentifier: "AccountPage") as! AccountViewController
        accountVC.delegate = (tabBarController!.viewControllers![0] as! UINavigationController).topViewController as! AccountViewControllerDelegate
        accountVC.modalTransitionStyle = modalTransitionStyle
        present(accountVC, animated: true) {
            self.tabBarController!.selectedIndex = 0
        }
    }

}
