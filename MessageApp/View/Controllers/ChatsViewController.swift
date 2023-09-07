//
//  ChatsViewController.swift
//  MessageApp
//
//  Created by Eyüphan Akkaya on 7.09.2023.
//

import UIKit

class ChatsViewController: UIViewController {

    var userID: Int?
    var user: Users?
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var messageBoxTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        if let users = user {
            userImageView.image = UIImage(named: "person")
            userNameLabel.text = users.name
            
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendMoreClicked(_ sender: Any) {
    }
    @IBAction func sendMessageClicked(_ sender: Any) {
    }
    @IBAction func backClicked(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
