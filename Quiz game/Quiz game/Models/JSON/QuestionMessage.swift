//
//  QuizModelCodable.swift
//  Quiz game
//
//  Created by Никита Пивоваров on 16.11.2022.
//

import Foundation

struct QuestionMessage: Codable {
    
    var messageType: String = "question"
    
    let question: String
    let firstAnswer: String
    let secondAnswer: String
    let thirdAnswer: String
    let fourthAnswer: String
    let answer: String
    let questionsAmount: [Int]
}
