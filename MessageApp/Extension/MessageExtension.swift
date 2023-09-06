//
//  MessageExtention.swift
//  MessageApp
//
//  Created by Eyüphan Akkaya on 6.09.2023.
//

import Foundation
import UIKit

extension MessageViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageTableViewCell
        tableView.rowHeight = 90
        return cell
    }
}
