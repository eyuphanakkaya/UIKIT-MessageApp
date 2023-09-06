//
//  Core .swift
//  MessageApp
//
//  Created by Eyüphan Akkaya on 5.09.2023.
//

import Foundation

class Core {
    static var shared = Core()
    
    func isNewUsers() -> Bool {
        return !UserDefaults.standard.bool(forKey: "isNewUser")
    }
    
    func setIsNotUser() {
        UserDefaults.standard.set(true, forKey: "isNewUser")
    }
}
