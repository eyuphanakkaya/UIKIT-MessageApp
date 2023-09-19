//
//  Cache.swift
//  MessageApp
//
//  Created by Eyüphan Akkaya on 19.09.2023.
//

import Foundation
import UIKit
class ImageCache {
    static func saveImage(_ image: UIImage, forKey key: String) {
        if let data = image.jpegData(compressionQuality: 1.0) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    static func getImage(forKey key: String) -> UIImage? {
        if let data = UserDefaults.standard.data(forKey: key) {
            return UIImage(data: data)
        }
        return nil
    }
}
