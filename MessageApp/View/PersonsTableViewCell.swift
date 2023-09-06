//
//  PersonsTableViewCell.swift
//  MessageApp
//
//  Created by Eyüphan Akkaya on 6.09.2023.
//

import UIKit

class PersonsTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViews: UIImageView!
    
    @IBOutlet weak var userPhoneLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func toMessageClicked(_ sender: Any) {
    }
}
