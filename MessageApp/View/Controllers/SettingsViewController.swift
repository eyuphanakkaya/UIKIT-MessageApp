//
//  SettingsViewController.swift
//  MessageApp
//
//  Created by Eyüphan Akkaya on 12.09.2023.
//

import UIKit
import Firebase
import FirebaseStorage

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    var viewModel = SettingsViewModel()
    var alert = Alerts()
    var myImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTextField.leftViewMode = .always
        emailTextField.leftViewMode = .always
        fullNameTextField.leftViewMode = .always
        
        passwordTextField.leftView = UIImageView(image: UIImage(systemName: "key"))
        emailTextField.leftView = UIImageView(image: UIImage(systemName: "envelope"))
        fullNameTextField.leftView = UIImageView(image: UIImage(systemName: "person"))
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePhoto))
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "persons")
        imageView.addGestureRecognizer(gesture)
        customView.layer.cornerRadius = 15
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        viewModel.fetchProfileImageForCurrentUser(imageView: imageView)
        viewModel.fetchLoginUser { user in

            guard let email = user.email,
               let password = user.password,
               let name = user.name else{
                return
            }
            self.emailTextField.text = email
            self.passwordTextField.text = password
            self.fullNameTextField.text = name
            
        }
    }
    @IBAction func logoutClicked(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            if let loginViewController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") {
                loginViewController.modalPresentationStyle = .fullScreen
                present(loginViewController, animated: true)
            }
            
            // Oturum durumunu kaydet
            //            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            //            UserDefaults.standard.synchronize()
        } catch {
            print("Çıkış yapılamadı")
        }
    }
    
    @objc private func didTapChangeProfilePhoto() {
        presentPhotoActionSheet()
    }
    
    @IBAction func updateClicked(_ sender: Any) {
        guard let email = emailTextField.text ,
              let name = fullNameTextField.text,
              let password = passwordTextField.text else {
            return
        }
        viewModel.updateLogin(email: email, name: name, password: password) { result  in
            print(result)
            if result {
                print(result)
                print("Hata")
            } else {
                self.alert.alert(title: "Updated", message: "Person updated.", viewControllers: self)
            }
        }
        guard let images = myImage else {
            return
        }
        viewModel.uploadImageToStorage(image: images)
        
        
    }


    
    
    
    
}

