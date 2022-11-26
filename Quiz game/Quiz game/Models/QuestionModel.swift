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
    @Published var questionsAmount: [Int]
    @Published var showButtons: Bool = true
    
    init(question: String = "", firstAnswer: String = "", secondAnswer: String = "", thirdAnswer: String = "", fourthAnswer: String = "", answer: String = "", questionsAmount: [Int] = [Int]()) {
        self.question = question
        self.firstAnswer = firstAnswer
        self.secondAnswer = secondAnswer
        self.thirdAnswer = thirdAnswer
        self.fourthAnswer = fourthAnswer
        self.answer = answer
        self.questionsAmount = questionsAmount
    }
    
    func setup(question: String, firstAnswer: String, secondAnswer: String, thirdAnswer: String, fourthAnswer: String, answer: String, questionsAmount: [Int]) {
        self.question = question
        self.firstAnswer = firstAnswer
        self.secondAnswer = secondAnswer
        self.thirdAnswer = thirdAnswer
        self.fourthAnswer = fourthAnswer
        self.answer = answer
        self.questionsAmount = questionsAmount
        self.showButtons = true
    }
}
