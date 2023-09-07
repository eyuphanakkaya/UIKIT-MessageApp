//
//  PersonExtension.swift
//  MessageApp
//
//  Created by Eyüphan Akkaya on 6.09.2023.
//

import Foundation
import UIKit

extension PersonsViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        myUsers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = myUsers[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as! PersonsTableViewCell
        cell.userNameLabel.text = user.name
        cell.userPhoneLabel.text = user.email
        cell.imageViews.image = UIImage(named: "person")
        tableView.rowHeight = 90
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "toChatVC", sender: indexPath.row)
    }
}
