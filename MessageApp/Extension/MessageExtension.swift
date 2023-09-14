//
//  MessageExtention.swift
//  MessageApp
//
//  Created by Eyüphan Akkaya on 6.09.2023.
//

import Foundation
import UIKit
import Firebase

extension MessageViewController: UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
           return  messageList.count
        } else {
           return searchList.count
        }
       
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = searchActive == true ? messageList[indexPath.row] : searchList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageTableViewCell
        cell.usersNameLabel.text = message.sender == loggedInUserId ? message.receiver : message.sender
        cell.shortMessageLabel.text = message.message
        cell.imageViews.image = myImage
        cell.imageViews.layer.cornerRadius = 25
        
        tableView.rowHeight = 90
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let message = searchActive == true ? messageList[indexPath.row] : searchList[indexPath.row]
        let vc = ChatViewController()
        vc.title = "Chat"
        vc.person = message
        if let users = Auth.auth().currentUser {
            self.loggedInUserId = users.email
            // Şimdi fetchPersons işlevini çağırabilirsiniz
            vc.senderUser = loggedInUserId
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let search = searchBar.text {
            searchList = messageList.filter{ message in
                if !search.isEmpty {
                    let searchTextMatch = message.receiver?.contains(search.lowercased())
                    return searchTextMatch ?? false
                } else {
                    return true
                }
            }
            tableView.reloadData()
            
        }
    }
}
