//
//  LikeTableViewCell.swift
//  Auto Plurk
//
//  Created by 乾太 on 2017/2/16.
//  Copyright © 2017年 乾太. All rights reserved.
//

import UIKit

class LikeTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var postedLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var imageStatus: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
