//
//  PersonsViewController.swift
//  MessageApp
//
//  Created by Eyüphan Akkaya on 6.09.2023.
//

import UIKit

class PersonsViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }
}
