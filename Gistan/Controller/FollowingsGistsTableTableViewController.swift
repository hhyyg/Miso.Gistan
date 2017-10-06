//
//  FollowingsGistsTableTableViewController.swift
//  Gistan
//
//  Created by Hiroka Yago on 2017/10/01.
//  Copyright © 2017 miso. All rights reserved.
//

import UIKit
import SafariServices
import Nuke

class FollowingsGistsTableTableViewController: UITableViewController {

    private var followingUsers: [User] = []
    private var gistItems: [GistItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "GistItemCell", bundle: nil)
        self.tableView?.register(nib, forCellReuseIdentifier: "ItemCell")

        //セルの高さを自動調整にする
        self.tableView.estimatedRowHeight = 30
        self.tableView.rowHeight = UITableViewAutomaticDimension

        load(userName: UserDefaults.standard.string(forKey: UserDefaultService.Key.userName.rawValue)!)
    }

    // UserのFollowsのGistを読み込む
    func load(userName: String) {
        let client = GitHubClient()
        let request = GitHubAPI.GetUsersFollowing(userName: userName)

        client.send(request: request) { result in
            switch result {
            case let .success(response):
                self.followingUsers = response
                self.loadFollowingUsersGists(client: client)
            case .failure(_):
                assertionFailure()
            }
        }
    }
    // FollowsのGistsを読み込む
    func loadFollowingUsersGists(client: GitHubClient) {

        var loadedUserCount = 0

        for user in followingUsers {
            let request = GitHubAPI.GetUsersGists(userName: user.login)
            client.send(request: request) { result in
                switch result {
                case let .success(response):
                    self.gistItems.append(contentsOf: response)
                    loadedUserCount += 1

                    if loadedUserCount == self.followingUsers.count {
                        self.gistItems.sort(by: { $0.createdAt > $1.createdAt })
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                case .failure(_):
                    assertionFailure()
                }
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gistItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! GistItemTableViewCell

        //TODO:value set
        let gistItem = gistItems[indexPath.row]
        cell.titleLabel?.text = "\(gistItem.owner.login) / \(gistItem.getFirstFileName())"
        cell.descriptionLabel?.text = "\(gistItem.getCreatedAtText()) \(gistItem.description)"
        cell.iconImageView?.image = nil
        Nuke.loadImage(with: URL(string: gistItem.owner.avatarUrl)!, into: cell.iconImageView!)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gistItem = gistItems[indexPath.row]

        let safariViewController = SFSafariViewController(url: URL(string: gistItem.htmlUrl)!)
        self.showDetailViewController(safariViewController, sender: nil)
    }
}
