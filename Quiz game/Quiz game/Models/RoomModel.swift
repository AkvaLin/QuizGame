//
//  RoomModel.swift
//  Quiz game
//
//  Created by Никита Пивоваров on 03.11.2022.
//

import SwiftUI
import Network

class RoomModel: Identifiable, ObservableObject {
    var id = UUID()
    @Published var name: String
    @Published var playersAmount: Int = 1
    @Published var maxPlayersAmount: Int
    @Published var players: [String] = [String]()
    var endPoint: NWEndpoint?
    
    init(id: UUID = UUID(), name: String, maxPlayersAmount: Int, endPoint: NWEndpoint?) {
        self.id = id
        self.name = name
        self.maxPlayersAmount = maxPlayersAmount
        self.endPoint = endPoint
    }
}
