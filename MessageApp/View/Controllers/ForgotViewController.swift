//
//  ForgotViewController.swift
//  MessageApp
//
//  Created by Eyüphan Akkaya on 6.09.2023.
//

import UIKit
import Firebase

class ForgotViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    var alert = Alerts()
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.leftViewMode = .always
        emailTextField.leftView = UIImageView(image: UIImage(systemName: "envelope"))

    }

    @IBAction func resetPasswordClicked(_ sender: Any) {
        if let email = emailTextField.text {
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    self.alert.alert(title: "Success", message: "Please check your email.", viewControllers: self)
                }
            }

        }
    }
    @IBAction func backClicked(_ sender: Any) {
        dismiss(animated: true)
    }
}
