//
//  ChatTableViewCell.swift
//  MessageApp
//
//  Created by Eyüphan Akkaya on 7.09.2023.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
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
