//
//  MessageTableViewCell.swift
//  MessageApp
//
//  Created by Eyüphan Akkaya on 6.09.2023.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var shortMessageLabel: UILabel!
    @IBOutlet weak var usersNameLabel: UILabel!
    @IBOutlet weak var imageViews: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
