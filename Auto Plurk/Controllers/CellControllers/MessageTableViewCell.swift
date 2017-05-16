//
//  MessageTableViewCell.swift
//  Auto Plurk
//
//  Created by 乾太 on 2017/2/20.
//  Copyright © 2017年 乾太. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    // Request 發文者
    @IBOutlet weak var requestImageView: UIImageView!
    @IBOutlet weak var requestUsername: UILabel!
    @IBOutlet weak var requestMessage: UILabel!
    @IBOutlet weak var requestPosttime: UILabel!

    // Response 回覆者
    @IBOutlet weak var responseImageView: UIImageView!
    @IBOutlet weak var responseUsername: UILabel!
    @IBOutlet weak var responseMessage: UILabel!
    @IBOutlet weak var responsePosttime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
