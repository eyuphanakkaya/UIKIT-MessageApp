//
//  LoginViewController.swift
//  MessageApp
//
//  Created by Eyüphan Akkaya on 6.09.2023.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    var alert = Alerts()
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

      
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMainVC" {
            if let tabBarController = segue.destination as? UITabBarController {
                if let navigationController = tabBarController.viewControllers?.first as? UINavigationController {
                    let index = sender as? String
                    if let mainViewController = navigationController.viewControllers.first as? PersonsViewController {
                        mainViewController.loggedInUserId = index
                    }
                }
            }
        }
    }


    @IBAction func loginClicked(_ sender: Any) {
        guard let email = emailTextField.text ,
              let password = passwordTextField.text else{
            alert.alert(title: "Error", message: "Please valid value enter.", viewControllers: self)
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) {[self] result, error in
            if  error != nil {
                alert.alert(title: "Error", message: "Please valid value enter.", viewControllers: self)
            } else if let email = result?.user.email {
                performSegue(withIdentifier: "toMainVC", sender: email)
            }
            
        }
        
    }
    @IBAction func forgotClicked(_ sender: Any) {
        if let forgot = storyboard?.instantiateViewController(withIdentifier: "ForgotVC") {
            forgot.modalPresentationStyle = .fullScreen
            present(forgot, animated: true)
        }
    }
}
