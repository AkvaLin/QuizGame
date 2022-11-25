//
//  QuizModel.swift
//  Quiz game
//
//  Created by Никита Пивоваров on 03.11.2022.
//

import Foundation

class QuizModel: Identifiable, ObservableObject {
    var id = UUID()
    @Published var name: String
    @Published var questionsModel = [QuestionModel]()
    
    init(id: UUID = UUID(), name: String, questionsModel: [QuestionModel] = [QuestionModel]()) {
        self.id = id
        self.name = name
        self.questionsModel = questionsModel
    }
    
    func updateView() {
        objectWillChange.send()
    }
}

extension QuizModel: Hashable {
    static func == (lhs: QuizModel, rhs: QuizModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
