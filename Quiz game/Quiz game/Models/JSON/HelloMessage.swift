//
//  HelloMessage.swift
//  Quiz game
//
//  Created by Никита Пивоваров on 16.11.2022.
//

import Foundation

struct HelloMessage: Codable {
    
    var messageType: String = "hello"
    
    let name: String
}
