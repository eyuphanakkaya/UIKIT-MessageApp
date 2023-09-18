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
        if !viewModel.searchActive {
            return viewModel.searchList.count
        } else if !segmentedState  {
            return 1
        } else {
            return viewModel.messageList.count
        }
   
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageTableViewCell
        func selectMessageType(filterMessages: Users) {
            cell.usersNameLabel.text = filterMessages.sender == viewModel.loggedInUserId ? filterMessages.receiver : filterMessages.sender
            cell.shortMessageLabel.text = filterMessages.message
            
            if let userImage = viewModel.myImage[filterMessages.receiver ?? ""] {
                // Kullanıcıya ait görüntüyü bulundu, kullanabilirsiniz.
                cell.imageViews.image = userImage
            } else {
                // Kullanıcıya ait görüntü bulunamadı, varsayılan görüntüyü kullanabilirsiniz.
                cell.imageViews.image = UIImage(named: "persons")
            }
            cell.usersNameLabel.text = filterMessages.sender == viewModel.loggedInUserId ? filterMessages.receiver : filterMessages.sender
            cell.shortMessageLabel.text = filterMessages.message
            
            if let userImage = viewModel.myImage[filterMessages.receiver ?? ""] {
                // Kullanıcıya ait görüntüyü bulundu, kullanabilirsiniz.
                cell.imageViews.image = userImage
            } else {
                // Kullanıcıya ait görüntü bulunamadı, varsayılan görüntüyü kullanabilirsiniz.
                cell.imageViews.image = UIImage(named: "persons")
            }
            cell.imageViews.layer.cornerRadius = 25
        }
        if segmentedState == true {
            let message = viewModel.searchActive == true ? viewModel.messageList[indexPath.row] : viewModel.searchList[indexPath.row]
            selectMessageType(filterMessages: message)
        } else {
            let lastMessage = viewModel.messageList.last
            if let user = lastMessage {
                selectMessageType(filterMessages: user)
            }
        }


        
        tableView.rowHeight = 90
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let message = viewModel.searchActive == true ? viewModel.messageList[indexPath.row] : viewModel.searchList[indexPath.row]
        let lastMessage = viewModel.messageList.last
        let vc = ChatViewController()
        vc.title = "Chat"
        vc.person = segmentedState == true ? message : lastMessage
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
