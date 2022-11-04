//
//  NewQuestionView.swift
//  Quiz game
//
//  Created by Никита Пивоваров on 03.11.2022.
//

import SwiftUI

struct NewQuestionView: View {
    
    @Binding var showNewQuestionView: Bool
    @Binding var questionModel: [QuestionModel]
    @ObservedObject var quizModel: QuizModel
    @ObservedObject var model: QuestionModel = QuestionModel()
    @State var question: String
    @State var firstAnswer: String
    @State var secondAnswer: String
    @State var thirdAnswer: String
    @State var fourthAnswer: String
    @State var answer: String
    @State var showAlert: Bool = false
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(.gray.opacity(0.2))
                .overlay {
                    TextField("Вопрос", text: $question)
                        .padding()
                }
                .padding()
            HStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.gray.opacity(0.2))
                    .overlay {
                        TextField("Вариант 1", text: $firstAnswer)
                            .padding()
                    }
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.gray.opacity(0.2))
                    .overlay {
                        TextField("Вариант 3", text: $thirdAnswer)
                            .padding()
                    }
            }
            .padding()
            HStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.gray.opacity(0.2))
                    .overlay {
                        TextField("Вариант 2", text: $secondAnswer)
                            .padding()
                    }
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.gray.opacity(0.2))
                    .overlay {
                        TextField("Вариант 4", text: $fourthAnswer)
                            .padding()
                    }
            }
            .padding()
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(.gray.opacity(0.2))
                .overlay {
                    TextField("Ответ", text: $answer)
                        .padding()
                }
                .padding()
            Button("Сохранить") {
                if !question.isEmpty,
                   !firstAnswer.isEmpty,
                   !secondAnswer.isEmpty,
                   !thirdAnswer.isEmpty,
                   !fourthAnswer.isEmpty,
                   !answer.isEmpty {
                    if model.question.isEmpty {
                        questionModel.append(QuestionModel(question: question,
                                                           firstAnswer: firstAnswer,
                                                           secondAnswer: secondAnswer,
                                                           thridAnswer: thirdAnswer,
                                                           fourthAnswer: fourthAnswer,
                                                           answer: answer))
                    } else {
                        model.question = question
                        model.firstAnswer = firstAnswer
                        model.secondAnswer = secondAnswer
                        model.thirdAnswer = thirdAnswer
                        model.fourthAnswer = fourthAnswer
                        model.answer = answer
                        quizModel.updateView()
                    }
                    showNewQuestionView = false
                } else {
                    showAlert = true
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .alert("Заполните все поля", isPresented: $showAlert) {
            Button("Ок", role: .cancel) { }
        }
    }
}
