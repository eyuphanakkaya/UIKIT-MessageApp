//
//  ChatExtension.swift
//  MessageApp
//
//  Created by Eyüphan Akkaya on 7.09.2023.
//

import Foundation
import UIKit

extension ChatsViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as? ChatTableViewCell
        tableView.rowHeight = 90
        return cell!
    }
}
