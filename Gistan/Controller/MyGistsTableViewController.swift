//
//  MyGistsTableViewController.swift
//  Gistan
//
//  Created by Hiroka Yago on 2017/09/30.
//  Copyright © 2017 miso. All rights reserved.
//

import UIKit
import SafariServices
import Nuke

class MyGistsTableViewController: UITableViewController, AccountViewControllerDelegate {

    private var gistItems: [GistItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        //アカウント設定に遷移
        let accountVC = self.storyboard?.instantiateViewController(withIdentifier: "AccountPage") as! AccountViewController
        accountVC.delegate = self
        accountVC.modalTransitionStyle = .coverVertical

        present(accountVC, animated: true, completion: nil)

        //CustomCellの設定
        let nib = UINib(nibName: "GistItemCell", bundle: nil)
        self.tableView?.register(nib, forCellReuseIdentifier: "ItemCell")

        //セルの高さを自動調整にする
        self.tableView.estimatedRowHeight = 30
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    func accountViewControllerDidDismiss(accountViewController: AccountViewController, userName: String) {
        load(userName: userName)
    }

    func load(userName: String) {
        let client = GitHubClient()
        let request = GitHubAPI.GetUsersGists(userName: userName)

        client.send(request: request) { result in
            switch result {
            case let .success(response):
                self.gistItems = response

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

            case .failure(_):
                assertionFailure()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

        //TODO:value set
        let gistItem = gistItems[indexPath.row]
        cell.titleLabel?.text = gistItem.getFirstFileName()
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

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
