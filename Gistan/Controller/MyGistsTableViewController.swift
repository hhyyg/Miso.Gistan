//
//  MyGistsTableViewController.swift
//  Gistan
//
//  Created by Hiroka Yago on 2017/09/30.
//  Copyright © 2017 miso. All rights reserved.
//

import UIKit
import SafariServices

class MyGistsTableViewController: UITableViewController {

    private var gistItems: [GistItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController!.navigationBar.prefersLargeTitles = true

        //CustomCellの設定
        let nib = UINib(nibName: "GistItemCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "ItemCell")

        //アカウント設定に遷移
        if UserService.loggedIn() {
            load()
        } else {
            goAccountViewController(modalTransitionStyle: .crossDissolve)
        }
    }

    func load() {
        let userName = KeychainService.get(forKey: .userName)!

        let client = GitHubClient()
        let request = GitHubAPI.GetUsersGists(userName: userName)

        client.send(request: request) { result in
            switch result {
            case let .success(response):
                self.gistItems = response

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

            case let .failure(error):
                logger.error(error)
                assertionFailure()
            }
        }
    }

    func goAccountViewController(modalTransitionStyle: UIModalTransitionStyle) {
        let accountVC = self.storyboard!.instantiateViewController(withIdentifier: "AccountPage") as! AccountViewController
        accountVC.delegate = self
        accountVC.modalTransitionStyle = modalTransitionStyle

        present(accountVC, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gistItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! GistItemTableViewCell

        let gistItem = gistItems[indexPath.row]
        cell.setItem(item: gistItem)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gistItem = gistItems[indexPath.row]

        let safariViewController = SFSafariViewController(url: URL(string: gistItem.htmlUrl)!)
        self.showDetailViewController(safariViewController, sender: nil)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension MyGistsTableViewController: AccountViewControllerDelegate {

    func accountViewControllerDidDismiss(accountViewController: AccountViewController) {
        load()
    }
}
