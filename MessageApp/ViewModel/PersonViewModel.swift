//
//  PersonViewModel.swift
//  MessageApp
//
//  Created by Eyüphan Akkaya on 15.09.2023.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

class PersonViewModel {
    var ref: DatabaseReference?
    var myUsers = [Users]()
    var filterUser = [Users]()
    var loggedInUserId: String?
    var searchActive = true
    init() {
        ref = Database.database().reference()
    }
     func persons(tableView: UITableView) {
        ref?.child("Users").observe(.value, with: { snapshot in
            if let gelenVeri = snapshot.value as? [String: Any] {
                self.myUsers.removeAll()
                for gelenSatir in gelenVeri {
                    if let sozluk = gelenSatir.value as? NSDictionary {
                        guard let name = sozluk["name"] as? String,
                              let lastName = sozluk["lastName"] as? String,
                              let email = sozluk["email"] as? String,
                              let password = sozluk["password"] as? String else{
                                  return
                              }
                        let myUsersItem = Users(image: "", name: name, lastName: lastName, email: email, password: password, sender: "", receiver: "", message: "", time: 0)
                        
                        self.myUsers.append(myUsersItem)
        
                        
                    }
                }
                for (index, user) in self.myUsers.enumerated() {
                    // Kullanıcının bilgilerini karşılaştırın (örneğin, kullanıcı adıyla karşılaştırma yapabilirsiniz)
                    if user.email == self.loggedInUserId {
                        // Giriş yapan kullanıcıyı listeden kaldırın
                        self.myUsers.remove(at: index)
                        break // Kullanıcıyı bulduktan sonra döngüden çıkın
                    }
                }
                DispatchQueue.main.async {
                    tableView.reloadData()
                    
                }
            }
        })
    }
}
