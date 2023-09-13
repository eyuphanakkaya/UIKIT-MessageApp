//
//  RegisterViewController.swift
//  MessageApp
//
//  Created by Eyüphan Akkaya on 6.09.2023.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    var viewModel: MessageViewModel?
    var ref: DatabaseReference?
    var alert = Alerts()
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.leftViewMode = .always
        passwordTextField.leftViewMode = .always
        lastNameTextField.leftViewMode = .always
        firstNameTextField.leftViewMode = .always
        
        emailTextField.leftView = UIImageView(image: UIImage(systemName: "envelope"))
        passwordTextField.leftView = UIImageView(image: UIImage(systemName: "key"))
        lastNameTextField.leftView = UIImageView(image: UIImage(systemName: "person.2"))
        firstNameTextField.leftView = UIImageView(image: UIImage(systemName: "person"))
        
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func loginClicked(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func createUserClicked(_ sender: Any) {
        guard let email = emailTextField.text ,
            let password = passwordTextField.text,
            let name = firstNameTextField.text,
            let lastName = lastNameTextField.text
        else{
            print("Oluşturulamadı...")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password)  { [self] result, error in
            if error != nil {
                alert.alert(title: "Error", message: "User is'nt created", viewControllers: self)
               
            } else {
                let user = Users(image: "", name: name, lastName: lastName, email: email, password: password, sender: "", receiver: "", message: "", time: 0)
                let dict = ["image": user.image, "name": user.name, "lastName": user.lastName, "email": user.email, "password": user.password]
                let newRef = ref?.child("Users").childByAutoId()
                newRef?.setValue(dict)
                alert.alert(title: "Success", message: "User is created", viewControllers: self)
                print("Kullanıcı oluştu")
            }
           
        }
        
    }
    @IBAction func backClicked(_ sender: Any) {
        dismiss(animated: true)
    }
}
