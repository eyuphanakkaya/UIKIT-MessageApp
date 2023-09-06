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
        1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as! PersonsTableViewCell
        tableView.rowHeight = 90
        return cell
    }
}
