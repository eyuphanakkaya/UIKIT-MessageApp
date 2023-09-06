//
//  RegisterViewController.swift
//  MessageApp
//
//  Created by Eyüphan Akkaya on 6.09.2023.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func loginClicked(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func createUserClicked(_ sender: Any) {
    }
    @IBAction func backClicked(_ sender: Any) {
        dismiss(animated: true)
    }
}
