//
//  QuestionModel.swift
//  Quiz game
//
//  Created by Никита Пивоваров on 03.11.2022.
//

import Foundation

class QuestionModel: Identifiable, ObservableObject {
    var id = UUID()
    @Published var question: String
    @Published var firstAnswer: String
    @Published var secondAnswer: String
    @Published var thirdAnswer: String
    @Published var fourthAnswer: String
    @Published var answer: String

    init(id: UUID = UUID(), question: String = "", firstAnswer: String = "", secondAnswer: String = "", thridAnswer: String = "", fourthAnswer: String = "", answer: String = "") {
        self.id = id
        self.question = question
        self.firstAnswer = firstAnswer
        self.secondAnswer = secondAnswer
        self.thirdAnswer = thridAnswer
        self.fourthAnswer = fourthAnswer
        self.answer = answer
    }
}
