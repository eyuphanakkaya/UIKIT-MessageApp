//
//  ForgotViewController.swift
//  MessageApp
//
//  Created by Eyüphan Akkaya on 6.09.2023.
//

import UIKit

class ForgotViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.leftViewMode = .always
        emailTextField.leftView = UIImageView(image: UIImage(systemName: "envelope"))

    }

    @IBAction func resetPasswordClicked(_ sender: Any) {
    }
    @IBAction func backClicked(_ sender: Any) {
        dismiss(animated: true)
    }
}
