//
//  MessageViewController.swift
//  MessageApp
//
//  Created by Eyüphan Akkaya on 6.09.2023.
//

import UIKit
import FirebaseStorage
import Firebase

class MessageViewController: UIViewController {
    var ref: DatabaseReference?
   
    var myImage: UIImage?
    var viewModel = MessageViewModel()
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        viewModel.messageList.sort(by: { $0.receiver ?? "" < $1.receiver ?? "" })
        viewModel.fetchMessagePersons(tableView: tableView)

    }
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchProfileImagesForReceivers(tableView: tableView)

    }


}
