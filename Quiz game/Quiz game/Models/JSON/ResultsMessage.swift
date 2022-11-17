//
//  ResultsMessage.swift
//  Quiz game
//
//  Created by Никита Пивоваров on 17.11.2022.
//

import Foundation

struct ResultsMessage: Codable {
    
    var messageType = "results"
    
    let results: [String: Int]
}
