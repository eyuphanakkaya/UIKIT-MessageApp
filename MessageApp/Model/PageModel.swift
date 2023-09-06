//
//  PageModel.swift
//  MessageApp
//
//  Created by Eyüphan Akkaya on 5.09.2023.
//

import Foundation

struct Page: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let imageUrl: String
    let tag: Int
    
    static var samplePages: [Page] = [
        Page(name: "Stay Connected!", description: "Enjoy the chat and connect with your friends around the world.Enjoy communication with our messaging app.", imageUrl: "image1", tag: 0),
        Page(name: "Fast and Secure Communication", description: "A powerful new way to communicate with instant messages, high-quality voice and video calls.", imageUrl: "image2", tag: 1),
        Page(name: "Closer, Better Connection", description: "Let nothing stop you from being close anymore.\nWe are ready for closer and better connection.", imageUrl: "image3", tag: 2)
    ]
}
