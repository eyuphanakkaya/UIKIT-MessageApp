//
//  LoginViewController.swift
//  MessageApp
//
//  Created by Eyüphan Akkaya on 6.09.2023.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func signUpClicked(_ sender: Any) {
        if let register = storyboard?.instantiateViewController(withIdentifier: "RegisterVC") {
            register.modalPresentationStyle = .fullScreen
            present(register, animated: true)
        }
    }
    @IBAction func googleClicked(_ sender: Any) {
    }
    @IBAction func facebookClicked(_ sender: Any) {
    }
    @IBAction func loginClicked(_ sender: Any) {
 
           
    }
    @IBAction func forgotClicked(_ sender: Any) {
        if let forgot = storyboard?.instantiateViewController(withIdentifier: "ForgotVC") {
            forgot.modalPresentationStyle = .fullScreen
            present(forgot, animated: true)
        }
    }
}
