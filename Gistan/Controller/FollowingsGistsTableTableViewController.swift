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
import RxSwift

class FollowingsGistsTableTableViewController: UITableViewController {

    private var followingUsers: [User] = []
    private var gistItems: [GistItem] = []
    private var isFirstAppeared = false

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController!.navigationBar.prefersLargeTitles = true

        let nib = UINib(nibName: "GistItemCell", bundle: nil)
        self.tableView?.register(nib, forCellReuseIdentifier: "ItemCell")

        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)

        //セルの高さを自動調整にする
        self.tableView.estimatedRowHeight = 30
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if !isFirstAppeared {
            isFirstAppeared = true
            self.refreshControl!.beginRefreshing()
            refreshData()
        }
    }

    private func refreshData() {
        if let userName = KeychainService.get(forKey: .userName) {
            load(userName: userName) {
                self.tableView.reloadData()
                self.refreshControl!.endRefreshing()
            }
        }
    }

    @objc func refresh(sender: UIRefreshControl) {
        self.gistItems = []
        self.followingUsers = []
        refreshData()
    }

    // UserのFollowsのGistを読み込む
    func load(userName: String,
              loadComplete: @escaping () -> Void) {

        let client = GitHubClient()
        let request = GitHubAPI.GetUsersFollowing(userName: userName)

        _ = client.send(request: request)
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { response in
                    self.followingUsers = response
                    self.loadFollowingUsersGists(client: client, loadComplete: loadComplete)
            },
                onError: { error in
                    logger.error(error)
                    loadComplete()
            })
    }
    // FollowsのGistsを読み込む
    func loadFollowingUsersGists(client: GitHubClient,
                                 loadComplete: @escaping () -> Void) {

        if followingUsers.count == 0 {
            loadComplete()
            return
        }

        var loadedUserCount = 0

        for user in followingUsers {
            let request = GitHubAPI.GetUsersGists(userName: user.login)

            _ = client.send(request: request)
                .observeOn(MainScheduler.instance)
                .subscribe(
                    onNext: { response in
                        self.gistItems.append(contentsOf: response)
                        loadedUserCount += 1

                        if loadedUserCount == self.followingUsers.count {
                            DispatchQueue.main.async {
                                self.gistItems.sort(by: { $0.createdAt > $1.createdAt })
                                loadComplete()
                            }
                        }
                    },
                    onError: { error in
                        logger.error(error)
                        loadComplete()
                })
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gistItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard gistItems.count > indexPath.row else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! GistItemTableViewCell

        let gistItem = gistItems[indexPath.row]
        cell.setItem(item: gistItem, forMe: false)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gistItem = gistItems[indexPath.row]

        let safariViewController = SFSafariViewController(url: URL(string: gistItem.htmlUrl)!)
        self.showDetailViewController(safariViewController, sender: nil)
    }
}
