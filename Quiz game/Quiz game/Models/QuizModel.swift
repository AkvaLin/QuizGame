//
//  QuizModel.swift
//  Quiz game
//
//  Created by Никита Пивоваров on 03.11.2022.
//

import Foundation

class QuizModel: Identifiable, ObservableObject {
    var id = UUID()
    @Published var name: String?
    @Published var questionsAmount: String?
    @Published var questionsModel = [QuestionModel]()
    
    init(id: UUID = UUID(), name: String? = nil, questionsAmount: String? = nil, questionsModel: [QuestionModel] = [QuestionModel]()) {
        self.id = id
        self.name = name
        self.questionsAmount = questionsAmount
        self.questionsModel = questionsModel
    }
    
    func updateView() {
        objectWillChange.send()
    }
}
