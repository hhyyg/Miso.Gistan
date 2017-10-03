//
//  AccountViewController.swift
//  Gistan
//
//  Created by Hiroka Yago on 2017/10/03.
//  Copyright © 2017 miso. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userNameTextField: UITextField!
    weak var delegate: AccountViewControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

        userNameTextField!.delegate = self
        userNameTextField!.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        guard let userName = userNameTextField!.text, !userName.isEmpty else {
            //TODO:入力してほしい感じ
            return false
        }
        self.delegate.didDismissViewController(accountViewController: self, userName: userName)
        self.dismiss(animated: true, completion: nil)

        return true
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

protocol AccountViewControllerDelegate: class {
    func didDismissViewController(accountViewController: AccountViewController, userName: String)
}
