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
    
    let emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "messages")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    let myLabel: UILabel = {
        let label = UILabel()
        label.text = "Not any message"
        label.contentMode = .scaleToFill
        return label
    }()
    @IBOutlet weak var titleLabel: UILabel!
    var segmentedState = true
    var ref: DatabaseReference?
    var viewModel = MainViewModel()
  
    var myImage: UIImage?
    //    var messageViewModel = MessageViewModel()
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        viewModel.fetchMessagePersons(tableView: tableView)

       
        
    }

    override func viewDidAppear(_ animated: Bool) {
        viewModel.fetchProfileImagesForReceivers(tableView: tableView)
        pageState()
    }
    
    func pageState() {
        if contentIsEmpty {
            view.addSubview(emptyImageView)
            view.addSubview(myLabel)
            emptyImageView.translatesAutoresizingMaskIntoConstraints = false
            myLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                emptyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                emptyImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                emptyImageView.widthAnchor.constraint(equalToConstant: 200), // Resim genişliğini ayarlayın
                emptyImageView.heightAnchor.constraint(equalToConstant: 200), // Resim yüksekliğini ayarlayın
                myLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: 16), // myLabel'ı emptyImageView'ın altına yerleştirir
                myLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
            searchBar.isHidden = true
            segmentedControl.isHidden = true
            titleLabel.isHidden = true
            
        }else {
            emptyImageView.removeFromSuperview()
            myLabel.removeFromSuperview()
            searchBar.isHidden = false
            segmentedControl.isHidden = false
            titleLabel.isHidden = false
        }
    }
    var contentIsEmpty: Bool {
        return viewModel.messageList.isEmpty
    }
    
    @IBAction func segmentedClicked(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            segmentedState = true
        case 1:
            segmentedState = false
        default :
            print("Error")
        }
        tableView.reloadData()
    }
    
}
