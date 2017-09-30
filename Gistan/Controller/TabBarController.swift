//
//  TabBarController.swift
//  Gistan
//
//  Created by Hiroka Yago on 2017/09/30.
//  Copyright © 2017 miso. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBar()
    }

    private func setupTabBar() {
        let items = tabBar.items!

        let gistsTab = items[0]
        gistsTab.title = "Your gists"

        let followTab = items[1]
        followTab.title = "Follows"
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
