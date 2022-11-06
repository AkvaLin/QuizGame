//
//  Quiz_gameApp.swift
//  Quiz game
//
//  Created by Никита Пивоваров on 11.09.2022.
//

import SwiftUI

@main
struct Quiz_gameApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: ViewModel(roomModel: [
                RoomModel(name: "Test1", address: "10.10.10.10", playersAmount: 16, maxPlayersAmount: 20),
                RoomModel(name: "Test1", address: "10.10.10.10", playersAmount: 16, maxPlayersAmount: 20),
                RoomModel(name: "Test1", address: "10.10.10.10", playersAmount: 16, maxPlayersAmount: 20),
                RoomModel(name: "Test1", address: "10.10.10.10", playersAmount: 16, maxPlayersAmount: 20),
                RoomModel(name: "Супер Длинное названиеееееееееееееееееееееееееееееее", address: "10.10.10.10", playersAmount: 16, maxPlayersAmount: 35),
                RoomModel(name: "Test1", address: "10.10.10.10", playersAmount: 16, maxPlayersAmount: 20),
                RoomModel(name: "Test1", address: "10.10.10.10", playersAmount: 16, maxPlayersAmount: 20),
                RoomModel(name: "Test1", address: "10.10.10.10", playersAmount: 16, maxPlayersAmount: 20),
                RoomModel(name: "Test1", address: "10.10.10.10", playersAmount: 16, maxPlayersAmount: 20),
                RoomModel(name: "Test1", address: "10.10.10.10", playersAmount: 16, maxPlayersAmount: 20),
                RoomModel(name: "Test1", address: "10.10.10.10", playersAmount: 16, maxPlayersAmount: 20),
                RoomModel(name: "Test1", address: "10.10.10.10", playersAmount: 16, maxPlayersAmount: 20),
                RoomModel(name: "Test1", address: "10.10.10.10", playersAmount: 16, maxPlayersAmount: 20),
                RoomModel(name: "Test1", address: "10.10.10.10", playersAmount: 16, maxPlayersAmount: 20),
            ],
                                          quizModel: [
                                            QuizModel(name: "Викторина", questionsModel: [QuestionModel]()),
                                            QuizModel(name: "Викторина", questionsModel: [QuestionModel]()),
                                            QuizModel(name: "Викторина", questionsModel: [QuestionModel]()),
                                            QuizModel(name: "Викторина", questionsModel: [QuestionModel]()),
                                            QuizModel(name: "Викторина", questionsModel: [QuestionModel]()),
                                            QuizModel(name: "Викторина", questionsModel: [QuestionModel]()),
                                            QuizModel(name: "Викторина", questionsModel: [QuestionModel]()),
                                            QuizModel(name: "Викторина", questionsModel: [QuestionModel]()),
                                            QuizModel(name: "Викторина", questionsModel: [QuestionModel]()),
                                            QuizModel(name: "Викторина", questionsModel: [QuestionModel]()),
                                            QuizModel(name: "Викторина", questionsModel: [QuestionModel]()),
                                            QuizModel(name: "Викторина", questionsModel: [QuestionModel]()),
                                            QuizModel(name: "Викторина", questionsModel: [QuestionModel]())
                                            ]
                                          )
            )
        }
    }
}
