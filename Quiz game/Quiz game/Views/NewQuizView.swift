//
//  NewQuizView.swift
//  Quiz game
//
//  Created by Никита Пивоваров on 03.11.2022.
//

import SwiftUI

struct NewQuizView: View {
    
    @State var quizName: String = ""
    @ObservedObject var quizModel: QuizModel
    @State var showNewQuestionView: Bool = false
    @State var question: QuestionModel? = nil
    
    var body: some View {
        
        NavigationView {
            VStack {
                TextField("", text: $quizName)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                Button("Добавить вопрос") {
                    self.question = nil
                    showNewQuestionView = true
                }
                List {
                    ForEach(quizModel.questionsModel) { question in
                        Button(question.question) {
                            self.question = question
                            showNewQuestionView = true
                        }
                    }
                    .onDelete(perform: delete)
                }
                .toolbar {
                    EditButton()
                }
            }
            .onDisappear {
                
            }
        }
        .sheet(isPresented: $showNewQuestionView) {
            if let question = self.question {
                NewQuestionView(showNewQuestionView: $showNewQuestionView,
                                questionModel: $quizModel.questionsModel,
                                quizModel: quizModel,
                                model: question,
                                question: question.question,
                                firstAnswer: question.firstAnswer,
                                secondAnswer: question.secondAnswer,
                                thirdAnswer: question.thirdAnswer,
                                fourthAnswer: question.fourthAnswer,
                                answer: question.answer)
            } else {
                NewQuestionView(showNewQuestionView: $showNewQuestionView,
                                questionModel: $quizModel.questionsModel,
                                quizModel: quizModel,
                                question: "",
                                firstAnswer: "",
                                secondAnswer: "",
                                thirdAnswer: "",
                                fourthAnswer: "",
                                answer: "")
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        quizModel.questionsModel.remove(atOffsets: offsets)
    }
}
