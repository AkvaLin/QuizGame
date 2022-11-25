//
//  AnswerMessage.swift
//  Quiz game
//
//  Created by Никита Пивоваров on 17.11.2022.
//

import Foundation

struct AnswerMessage: Codable {
    
    var messageType: String = "answer"

    let answer: Bool
}
