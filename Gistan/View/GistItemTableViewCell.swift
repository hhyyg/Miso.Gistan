//
//  GistItemTableViewCell.swift
//  Gistan
//
//  Created by Hiroka Yago on 2017/10/02.
//  Copyright © 2017 miso. All rights reserved.
//

import UIKit

class GistItemTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
