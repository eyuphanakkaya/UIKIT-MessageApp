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
        if viewModel.searchActive {
            return  viewModel.messageList.count
        } else {
            return viewModel.searchList.count
        }
       
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = viewModel.searchActive == true ? viewModel.messageList[indexPath.row] : viewModel.searchList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageTableViewCell
        cell.usersNameLabel.text = message.sender == viewModel.loggedInUserId ? message.receiver : message.sender
        cell.shortMessageLabel.text = message.message
        
        if let userImage = viewModel.myImage[message.receiver ?? ""] {
            // Kullanıcıya ait görüntüyü bulundu, kullanabilirsiniz.
            print(message.receiver)
            cell.imageViews.image = userImage
        } else {
            // Kullanıcıya ait görüntü bulunamadı, varsayılan görüntüyü kullanabilirsiniz.
            cell.imageViews.image = UIImage(named: "persons")
        }
        cell.imageViews.layer.cornerRadius = 25
        
        tableView.rowHeight = 90
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let message = viewModel.searchActive == true ? viewModel.messageList[indexPath.row] : viewModel.searchList[indexPath.row]
        let vc = ChatViewController()
        vc.title = "Chat"
        vc.person = message
        if let users = Auth.auth().currentUser {
            viewModel.loggedInUserId = users.email
            // Şimdi fetchPersons işlevini çağırabilirsiniz
            vc.senderUser = viewModel.loggedInUserId
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        viewModel.searchActive = false
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let search = searchBar.text {
            viewModel.searchList = viewModel.messageList.filter{ message in
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
