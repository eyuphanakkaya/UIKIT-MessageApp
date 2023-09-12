//
//  SettingsViewController.swift
//  MessageApp
//
//  Created by Eyüphan Akkaya on 12.09.2023.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logOutClicked(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            let userDefaults = UserDefaults.standard
            userDefaults.set(false, forKey: "isLoggedIn")
            self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
        } catch {
            print("Çıkış yapılamadı")
        }
       
    }
    
}
