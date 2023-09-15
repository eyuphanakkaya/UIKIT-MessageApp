//
//  SettingViewModel.swift
//  MessageApp
//
//  Created by Eyüphan Akkaya on 15.09.2023.
//

import Foundation
import Firebase
import FirebaseStorage
import UIKit

class SettingsViewModel {
    var loginUser: String?
    var ref: DatabaseReference?
    var alert = Alerts()
    var viewControllers: UIViewController?
    
    init() {
        if let user = Auth.auth().currentUser {
            loginUser = user.email
        }
        ref = Database.database().reference()
    }
    func updateLogin(email: String,name: String,password: String,completion: @escaping (Bool)->Void) {
        ref?.child("Users").queryOrdered(byChild: "email").queryEqual(toValue: email).observeSingleEvent(of: .value, with: { snapShot in
            if let userSnapshot = snapShot.children.allObjects.first as? DataSnapshot,
               let userId = userSnapshot.key as? String {
                let dict : [String: Any] = ["email":email,"name":name,"password":password]
                self.ref?.child("Users").child(userId).updateChildValues(dict,withCompletionBlock: { error,result in
                    if error != nil {
                        print("Hata")
                        completion(true)
                    } else {
                        completion(false)
                    }
                    
                })
            }
        })
    }
    func uploadImageToStorage(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            return
        }
        let storageRef = Storage.storage().reference()
        let email = loginUser ?? ""
        let imageName = "resim.jpg" // Kaydedilecek resmin adı
        
        let imageRef = storageRef.child("images/\(email)/\(imageName)")

        imageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Yükleme Hatası: \(error.localizedDescription)")
            } else {
                print("yükleme başarılı")
            }
        }
    }
    func fetchLoginUser(completion: @escaping(Users)->Void) {
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
                        completion(findLogin)
                    }
                    
                    
                }
            }
            
        })
    }
    func fetchProfileImageForCurrentUser(imageView: UIImageView) {
        guard let loginUser = loginUser else {
            return
        }
        
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child("images/\(loginUser)/resim.jpg") // Resmin yolunu belirtin
        
        // Resmi indirme işlemi
        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("Resim indirme hatası: \(error.localizedDescription)")
            } else if let data = data, let image = UIImage(data: data) {
                // Resmi görüntüleme
                imageView.image = image
            }
        }
    }
    
}

