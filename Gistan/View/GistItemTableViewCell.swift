//
//  GistItemTableViewCell.swift
//  Gistan
//
//  Created by Hiroka Yago on 2017/10/02.
//  Copyright © 2017 miso. All rights reserved.
//

import UIKit
import Nuke

class GistItemTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var secretLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        separatorInset.left = titleLabel.convert(titleLabel.bounds.origin, to: self).x
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setItem(item: GistItem, forMe: Bool) {
        if forMe {
            self.secretLabel.isHidden = item.isPublic
            self.titleLabel.text = "\(item.getFirstFileName())"
        } else {
            self.secretLabel.isHidden = true
            self.titleLabel.text = "\(item.owner.login) / \(item.getFirstFileName())"
        }
        self.descriptionLabel.text = "\(item.getCreatedAtText()) \(item.description ?? "")"
        self.iconImageView.image = nil
        Nuke.loadImage(with: URL(string: item.owner.avatarUrl)!, into: self.iconImageView!)
    }
}
