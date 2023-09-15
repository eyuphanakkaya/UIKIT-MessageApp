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
    var alert = Alerts()
    var list = [Users]()
    var loginUser: String?
    var ref: DatabaseReference?
    var myImage: UIImage?
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
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        fetchProfileImageForCurrentUser()
        fetchLoginUser()
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
            guard let images = myImage else {
                return
            }
            uploadImageToStorage(image: images)
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
                          let password = dict["password"] as? String else{
                        return
                    }
                    let findLogin = Users(image: "", name: name, lastName: lastName, email: email, password: password, sender: "", receiver: "", message: "", time: 0)

                    if email == self.loginUser {
                        self.emailTextField.text = findLogin.email
                        self.passwordTextField.text = findLogin.password
                        self.fullNameTextField.text = findLogin.name
//                             self.imageView.image = findLogin.image

                    }

                }
            }

        })
    }
    func uploadImageToStorage(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            // Resmi veriye dönüştürme hatası
            return
        }
        
        let storageRef = Storage.storage().reference()
        let email = loginUser ?? "" // Kullanıcının e-posta adresini kullanarak resmin yolunu belirleyin
        let imageName = "resim.jpg" // Kaydedilecek resmin adı
        
        let imageRef = storageRef.child("images/\(email)/\(imageName)")
        
        // Resmi Firebase Storage'a yükle
        imageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                // Yükleme hatası
                print("Yükleme Hatası: \(error.localizedDescription)")
            } else {
                // Yükleme başarılı
               // print("Resim başarıyla yüklendi.")
                
                // Yükleme sonrası işlemleri burada gerçekleştirebilirsiniz.
            }
        }
    }
    func fetchProfileImageForCurrentUser() {
        guard let loginUser = loginUser else {
            return
        }
        
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child("images/\(loginUser)/resim.jpg") // Resmin yolunu belirtin
        
        // Resmi indirme işlemi
        imageRef.getData(maxSize: 1 * 1024 * 1024) { [weak self] data, error in
            if let error = error {
                print("Resim indirme hatası: \(error.localizedDescription)")
            } else if let data = data, let image = UIImage(data: data) {
                // Resmi görüntüleme
                self?.imageView.image = image
            }
        }
    }



    func updateLogin(email: String,name: String,password: String) {
        ref?.child("Users").queryOrdered(byChild: "email").queryEqual(toValue: email).observeSingleEvent(of: .value, with: { snapShot in
            if let userSnapshot = snapShot.children.allObjects.first as? DataSnapshot,
               let userId = userSnapshot.key as? String {
                    let dict : [String: Any] = ["email":email,"name":name,"password":password]
                    self.ref?.child("Users").child(userId).updateChildValues(dict,withCompletionBlock: { error,result in
                        if error != nil {
                            print("Hata")
                        } else {
                            self.alert.alert(title: "Updated", message: "Person updated.", viewControllers: self)
                        }
                        
                    })
            }
        })
    }
}

