//
//  Users.swift
//  MessageApp
//
//  Created by Eyüphan Akkaya on 7.09.2023.
//

import Foundation

struct Users: Identifiable {
    let id = UUID()
    let image: String?
    let name: String?
    let lastName: String?
    let email: String?
    let password: String?
    let sender: String?
    let receiver: String?
    let message: String?
    let time: Double?
}
