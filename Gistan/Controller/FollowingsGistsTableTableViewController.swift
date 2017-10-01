//
//  FollowingsGistsTableTableViewController.swift
//  Gistan
//
//  Created by Hiroka Yago on 2017/10/01.
//  Copyright © 2017 miso. All rights reserved.
//

import UIKit
import SafariServices

class FollowingsGistsTableTableViewController: UITableViewController {

    private var followingUsers: [User] = []
    private var gistItems: [GistItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        load(userName: "hhyyg")
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
        for user in followingUsers {

            let request = GitHubAPI.GetUsersGists(userName: user.login)

            client.send(request: request) { result in
                switch result {
                case let .success(response):
                    self.gistItems.append(contentsOf: response)
                    //TODO: 毎回並び替えしない
                    self.gistItems.sort(by: { $0.createdAt > $1.createdAt })

                    //TODO: 毎回reloadしなくてよいようにする
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "GistItemCell", for: indexPath)

        let gistItem = gistItems[indexPath.row]
        cell.textLabel?.text = "\(gistItem.owner.login) / \(gistItem.getFirstFileName())"
        cell.detailTextLabel?.text = "\(gistItem.getCreatedAtText()) \(gistItem.description)"

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gistItem = gistItems[indexPath.row]

        let safariViewController = SFSafariViewController(url: URL(string: gistItem.htmlUrl)!)
        self.showDetailViewController(safariViewController, sender: nil)
    }
}
