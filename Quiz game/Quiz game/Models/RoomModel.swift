//
//  RoomModel.swift
//  Quiz game
//
//  Created by Никита Пивоваров on 03.11.2022.
//

import SwiftUI

class RoomModel: Identifiable, ObservableObject {
    var id = UUID()
    @Published var name: String
    @Published var address: String
    @Published var playersAmount: String
    
    init(id: UUID = UUID(), name: String, address: String, playersAmount: String) {
        self.id = id
        self.name = name
        self.address = address
        self.playersAmount = playersAmount
    }
}
