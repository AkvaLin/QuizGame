//
//  NewQuizView.swift
//  Quiz game
//
//  Created by Никита Пивоваров on 03.11.2022.
//

import SwiftUI

struct NewQuizView: View {
    
    @ObservedObject var quizModel: QuizModel
    @ObservedObject var viewModel: ViewModel
    @Binding var showView: Bool
    @State var showNewQuestionView: Bool = false
    @State var question: QuestionModel? = nil
    @State var showAlert: Bool = false
    
    init(quizModel: QuizModel, viewModel: ViewModel, showView: Binding<Bool>) {
        self.quizModel = quizModel
        self.viewModel = viewModel
        self._showView = showView
    }
    
    var body: some View {
        
        NavigationView {
            VStack {
                TextField("Название викторины", text: $quizModel.name)
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
                
                Button {
                    if quizModel.questionsModel.count < 1 {
                        showAlert = true
                    } else {
                        if !viewModel.quizModel.contains(quizModel) {
                            viewModel.quizModel.append(quizModel)
                        } else {
                            viewModel.objectWillChange.send()
                        }
                        showView = false
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
        .alert("Добавьте хотя бы один вопрос", isPresented: $showAlert) {
            Button("Ок", role: .none) { }
        }
        .onDisappear {
            if quizModel.questionsModel.count < 1 {
                guard let index = viewModel.quizModel.firstIndex(of: quizModel) else { return }
                viewModel.quizModel.remove(at: index)
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        quizModel.questionsModel.remove(atOffsets: offsets)
    }
}
