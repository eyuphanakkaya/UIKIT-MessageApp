//
//  Alerts.swift
//  MessageApp
//
//  Created by Eyüphan Akkaya on 7.09.2023.
//

import Foundation
import UIKit

class Alerts {
    func alert(title: String, message: String,viewControllers: UIViewController) {
        let alerts = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Okay", style: .cancel)
        alerts.addAction(alertAction)
        viewControllers.present(alerts, animated: true)
    }
}
