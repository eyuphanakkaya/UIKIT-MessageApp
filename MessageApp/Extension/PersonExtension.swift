//
//  PersonExtension.swift
//  MessageApp
//
//  Created by Eyüphan Akkaya on 6.09.2023.
//

import Foundation
import UIKit

extension PersonsViewController: UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return  myUsers.count
        } else {
            return  filterUser.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = searchActive == true ? myUsers[indexPath.row] : filterUser[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as! PersonsTableViewCell
        cell.userNameLabel.text = user.name
        cell.userPhoneLabel.text = user.email
        cell.imageViews.image = UIImage(named: "person")
        tableView.rowHeight = 90
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = myUsers[indexPath.row]
        let vc = ChatViewController()
        vc.title = "Chat"
        vc.person = user
        vc.senderUser = loggedInUserId
        
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchActive = true
        if let search = searchBar.text {
            filterUser = myUsers.filter({$0.name.contains(search)})
            tableView.reloadData()
        }
    }
}
