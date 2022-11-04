//
//  ViewModel.swift
//  Quiz game
//
//  Created by Никита Пивоваров on 03.11.2022.
//

import Foundation

class ViewModel: ObservableObject {
    
    @Published var roomModel: [RoomModel]?
    @Published var quizModel = [QuizModel]()
    
    init(roomModel: [RoomModel]? = nil, quizModel: [QuizModel] = [QuizModel]()) {
        self.roomModel = roomModel
        self.quizModel = quizModel
    }
}
