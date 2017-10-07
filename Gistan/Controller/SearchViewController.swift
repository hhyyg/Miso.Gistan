//
//  SearchViewController.swift
//  Gistan
//
//  Created by Hiroka Yago on 2017/10/07.
//  Copyright © 2017 miso. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController, UISearchResultsUpdating {

    var searchController = UISearchController(searchResultsController: nil)

    var searchResults = [String]()

    let dataList = ["月刊コロコロコミック（小学館）",
                    "コロコロイチバン！（小学館）",
                    "最強ジャンプ（集英社）",
                    "Vジャンプ（集英社）",
                    "週刊少年サンデー（小学館）",
                    "週刊少年マガジン（講談社）",
                    "週刊少年ジャンプ（集英社）",
                    "週刊少年チャンピオン（秋田書店）",
                    "月刊少年マガジン（講談社）",
                    "月刊少年チャンピオン（秋田書店）",
                    "月刊少年ガンガン（スクウェア）",
                    "月刊少年エース（KADOKAWA）",
                    "月刊少年シリウス（講談社）",
                    "週刊ヤングジャンプ（集英社）",
                    "ビッグコミックスピリッツ（小学館）",
                    "週刊ヤングマガジン（講談社）"]

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController!.navigationBar.prefersLargeTitles = true

        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestCell", for: indexPath)
        if( searchController.searchBar.text != "" ) {
            cell.textLabel!.text = searchResults[indexPath.row]
        } else {
            cell.textLabel!.text = dataList[indexPath.row]
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if( searchController.searchBar.text != "" ) {
            return searchResults.count
        } else {
            return dataList.count
        }
    }

    func updateSearchResults(for searchController: UISearchController) {
        searchResults = dataList.filter { data in
            return data.contains(searchController.searchBar.text!)
        }

        tableView.reloadData()
    }
}
