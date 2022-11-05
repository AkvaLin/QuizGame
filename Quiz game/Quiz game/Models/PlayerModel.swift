//
//  PlayerModel.swift
//  Quiz game
//
//  Created by Никита Пивоваров on 04.11.2022.
//

import Foundation

class PlayerModel: Identifiable, ObservableObject {
    var id = UUID()
    @Published var name: String
    
    init(name: String) {
        self.name = name
    }
}
