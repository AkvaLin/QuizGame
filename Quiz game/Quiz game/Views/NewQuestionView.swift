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
    @State var answerNumber: Int = 1
    @State var showAlert: Bool = false
    @Environment(\.dismiss) var dismiss
    
    @State var answer: String = ""
    private let answerNumbers = Array(1...4)
    
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
                        TextField("Вариант 2", text: $secondAnswer)
                            .padding()
                    }
            }
            .padding()
            HStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.gray.opacity(0.2))
                    .overlay {
                        TextField("Вариант 3", text: $thirdAnswer)
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
                    HStack {
                        Text("Ответ: ")
                        Picker("", selection: $answerNumber) {
                            ForEach(answerNumbers, id: \.self) { amount in
                                Text("\(amount)")
                            }
                        }
                    }
                    .padding()
                }
                .padding()
            Button {
                
                switch answerNumber {
                case 1:
                    answer = firstAnswer
                case 2:
                    answer = secondAnswer
                case 3:
                    answer = thirdAnswer
                case 4:
                    answer = fourthAnswer
                default:
                    break
                }
                
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
                                                           thirdAnswer: thirdAnswer,
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
                    dismiss()
                } else {
                    showAlert = true
                }
            } label: {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("Сохранить")
                        Spacer()
                    }
                    Spacer()
                }
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 15))
            .frame(width: 320, height: 50)
            .padding()
        }
        .alert("Заполните все поля", isPresented: $showAlert) {
            Button("Ок", role: .cancel) { }
        }
    }
}
