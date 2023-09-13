//
//  SettingsViewController.swift
//  MessageApp
//
//  Created by Eyüphan Akkaya on 12.09.2023.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    var alert = Alerts()
    var list = [Users]()
    var loginUser: String?
    var ref: DatabaseReference?
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
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
        
        if let user =  Auth.auth().currentUser {
            loginUser = user.email
            print(user.uid)
        }
       
    }
    override func viewDidAppear(_ animated: Bool) {
        fetchLoginUser()
        for x in list {
            print("Adı\(x.email)")
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
        if let email = emailTextField.text ,
           let name = fullNameTextField.text,
           let password = passwordTextField.text {
            updateLogin(email: email, name: name, password: password)
            alert.alert(title: "Updated", message: "Person updated.", viewControllers: self)
        } else {
            print("güncellenmedi")
        }
        
    }
    
    func fetchLoginUser() {
        ref?.child("Users").observe(.value, with: { snapShot in
            guard let incomingData = snapShot.value as? [String: Any] else{
                print("Veri çekilemedi")
                return
            }
            for incomingLine in incomingData {
                if let dict = incomingLine.value as? NSDictionary {
                    guard let email = dict["email"] as? String,
                    let name = dict["name"] as? String,
                    let lastName = dict["lastName"] as? String,
                    let password = dict["password"] as? String,
                    let image = dict["image"] as? String else{
                        return
                    }
                    let findLogin = Users(image: image, name: name, lastName: lastName, email: email, password: password, sender: "", receiver: "", message: "", time: 0)
                    self.list.append(findLogin)
                       

                }
            }
            for (index, user) in self.list.enumerated() {
                // Kullanıcının bilgilerini karşılaştırın (örneğin, kullanıcı adıyla karşılaştırma yapabilirsiniz)
                if user.email != self.loginUser {
                    // Giriş yapan kullanıcıyı listeden kaldırın
                    self.list.remove(at: index)
                    return // Kullanıcıyı bulduktan sonra döngüden çıkın
                }
            }
        })
    }
    func  updateLogin(email: String,name: String,password: String) {
        if let id = Auth.auth().currentUser?.uid {
            print(id)
            let dict : [String: Any] = ["email":email,"name": name,"password": password]
            ref?.child("Users").child(id).updateChildValues(dict)
        }
    }
}
extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture",
                                            message: "How would you like to select a picture?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default,handler: { [weak self]_ in
                self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default,handler: { [weak self] _ in
                self?.presentPhotoPicker()
        }))
        present(actionSheet, animated: true)
    }
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
        
    }
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {//seçimi bırakırsa
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
            return
        }
        self.imageView.image = selectedImage
      
    }
    
}
