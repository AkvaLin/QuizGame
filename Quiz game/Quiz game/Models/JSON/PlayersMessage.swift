//
//  PlayersMessage.swift
//  Quiz game
//
//  Created by Никита Пивоваров on 17.11.2022.
//

import Foundation

struct PlayersMessage: Codable {
    
    var messageType: String = "players"
    
    let playersAmount: String
    let maxPlayersAmount: String
    let playersName: [String]
}
