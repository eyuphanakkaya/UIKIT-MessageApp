//
//  LoginViewController.swift
//  MessageApp
//
//  Created by Eyüphan Akkaya on 6.09.2023.
//

import UIKit
import Firebase
import GoogleSignInSwift
import GoogleSignIn
import FacebookCore
import FBSDKLoginKit


class LoginViewController: UIViewController {
    var alert = Alerts()
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.leftViewMode = .always
        emailTextField.leftView = UIImageView(image: UIImage(systemName: "envelope"))
        passwordTextField.leftViewMode = .always
        passwordTextField.leftView = UIImageView(image: UIImage(systemName: "key"))
              
    }

    @IBAction func signUpClicked(_ sender: Any) {
        if let register = storyboard?.instantiateViewController(withIdentifier: "RegisterVC") {
            register.modalPresentationStyle = .fullScreen
            present(register, animated: true)
        }
    }
    @IBAction func googleClicked(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            if let error = error {
                // Hata işleme kodunu burada ekleyebilirsiniz
                print("Google girişi başarısız: \(error.localizedDescription)")
                self.alert.alert(title: "Error", message: "\(error.localizedDescription)", viewControllers: self)
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                print("Kullanıcı bilgisi yok")
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { result, error in
                guard error == nil else {
                    self.alert.alert(title: "Error", message: "Please true value enter.", viewControllers: self)
                    return
                }
                    self.performSegue(withIdentifier: "toMainVC", sender: nil)

            }
            
        }
    }
    @IBAction func facebookClicked(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions:["email", "user_friends"],
 from: self) { result, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let accesToken = AccessToken.current else{
                print("Failed to get access token")
                return
            }
            let crendential = FacebookAuthProvider.credential(withAccessToken: accesToken.tokenString)
            
            Auth.auth().signIn(with: crendential) { result, error in
                if let error = error {
                    print(error.localizedDescription)
                    self.alert.alert(title: "Error", message: "\(error.localizedDescription)", viewControllers: self)
                } else {
                    self.performSegue(withIdentifier: "toMainVC", sender: nil)
                    
                }
            }
        }
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
        getLogin(email: email, password: password)
        
    }
    @IBAction func forgotClicked(_ sender: Any) {
        if let forgot = storyboard?.instantiateViewController(withIdentifier: "ForgotVC") {
            forgot.modalPresentationStyle = .fullScreen
            present(forgot, animated: true)
        }
    }
    func getLogin(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) {[self] result, error in
            if  error != nil {
                alert.alert(title: "Error", message: "Please valid value enter.", viewControllers: self)
            } else if let email = result?.user.email {
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                UserDefaults.standard.synchronize()
                performSegue(withIdentifier: "toMainVC", sender: email)

               
            }
            
        }
    }
}
