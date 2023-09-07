//
//  PersonsViewController.swift
//  MessageApp
//
//  Created by Eyüphan Akkaya on 6.09.2023.
//

import UIKit
import Firebase

class PersonsViewController: UIViewController {

    var loggedInUserId: String?
    var myUsers = [Users]()
    var ref: DatabaseReference?
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        
        print(loggedInUserId)
        tableView.dataSource = self
        tableView.delegate = self
        persons()
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toChatVC" {
            let index = sender as? Int
            let toDestionation = segue.destination as? ChatsViewController
            toDestionation?.user = myUsers[index!]
        }
    }
    
    func persons() {
        ref?.child("Users").observe(.value, with: { snapshot in
            if let gelenVeri = snapshot.value as? [String: Any] {
                self.myUsers.removeAll()
                for gelenSatir in gelenVeri {
                    if let sozluk = gelenSatir.value as? NSDictionary {
                        guard let image = sozluk["image"] as? String,
                              let name = sozluk["name"] as? String,
                              let lastName = sozluk["lastName"] as? String,
                              let email = sozluk["email"] as? String,
                              let password = sozluk["password"] as? String else{
                                  return
                              }
                        let myUsersItem = Users(image: image, name: name, lastName: lastName, email: email, password: password)
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
                    self.tableView.reloadData()
                    
                }
            }
        })
    }
}
