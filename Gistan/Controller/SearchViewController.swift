//
//  SearchViewController.swift
//  Gistan
//
//  Created by Hiroka Yago on 2017/10/07.
//  Copyright © 2017 miso. All rights reserved.
//

import UIKit
import SafariServices
import RxSwift

class SearchViewController: UITableViewController, UISearchResultsUpdating {

    private var searchController = UISearchController(searchResultsController: nil)
    private var gistItems: [GistItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        //CustomCellの設定
        let nib = UINib(nibName: "GistItemCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "ItemCell")

        self.definesPresentationContext = true
        navigationController!.navigationBar.prefersLargeTitles = true
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "user name"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
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
        guard gistItems.count > indexPath.row else {
            return
        }
        let gistItem = gistItems[indexPath.row]

        let safariViewController = SFSafariViewController(url: URL(string: gistItem.htmlUrl)!)
        self.showDetailViewController(safariViewController, sender: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.gistItems.count
    }

    func searchUserGists(userName: String) {

        let client = GitHubClient()
        let request = GitHubAPI.GetUsersGists(userName: userName)
        _ = client.send(request: request)
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { response in
                    self.gistItems = response
                    self.tableView.reloadData()
            },
                onError: { error in
                    ()
            })
    }

    func updateSearchResults(for searchController: UISearchController) {

        guard let inputText = searchController.searchBar.text,
            !inputText.isEmpty else {
            return
        }

        self.searchUserGists(userName: inputText)
    }
}
