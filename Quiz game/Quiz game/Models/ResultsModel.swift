//
//  ResultsModel.swift
//  Quiz game
//
//  Created by Никита Пивоваров on 25.11.2022.
//

import Foundation

class ResultsModel: ObservableObject, Identifiable {
    
    let playerName: String
    let playerScore: Int
    let id: UUID
    
    init(playerName: String, playerScore: Int) {
        self.playerName = playerName
        self.playerScore = playerScore
        self.id = UUID()
    }
}

extension ResultsModel: Comparable {
    static func < (lhs: ResultsModel, rhs: ResultsModel) -> Bool {
        return lhs.playerScore > rhs.playerScore
    }
    
    static func == (lhs: ResultsModel, rhs: ResultsModel) -> Bool {
        return lhs.playerScore == rhs.playerScore
    }
}
