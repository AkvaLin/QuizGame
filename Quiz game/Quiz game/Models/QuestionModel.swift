//
//  QuestionModel.swift
//  Quiz game
//
//  Created by Никита Пивоваров on 03.11.2022.
//

import Foundation

class QuestionModel: Identifiable, ObservableObject {
    @Published var question: String
    @Published var firstAnswer: String
    @Published var secondAnswer: String
    @Published var thirdAnswer: String
    @Published var fourthAnswer: String
    @Published var answer: String
    
    init(question: String = "", firstAnswer: String = "", secondAnswer: String = "", thridAnswer: String = "", fourthAnswer: String = "", answer: String = "") {
        self.question = question
        self.firstAnswer = firstAnswer
        self.secondAnswer = secondAnswer
        self.thirdAnswer = thridAnswer
        self.fourthAnswer = fourthAnswer
        self.answer = answer
    }
}
