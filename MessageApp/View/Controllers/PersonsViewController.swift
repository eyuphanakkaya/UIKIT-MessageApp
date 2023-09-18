//
//  PersonsViewController.swift
//  MessageApp
//
//  Created by Eyüphan Akkaya on 6.09.2023.
//

import UIKit
import Firebase
import FirebaseStorage

class PersonsViewController: UIViewController {
    var loggedInUserId: String?
    var personViewModel = PersonViewModel()
    var viewModel = MainViewModel()
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        personViewModel.loggedInUserId = loggedInUserId
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        personViewModel.myUsers.sort(by: { $0.email ?? "" < $1.email ?? "" })
        personViewModel.persons(tableView: tableView)
        viewModel.fetchMessagePersons(tableView: tableView)
       
    }
//    override func viewWillAppear(_ animated: Bool) {
//      
//        viewModel.fetchProfileImagesForReceivers(tableView: tableView)
//    }

    

}
