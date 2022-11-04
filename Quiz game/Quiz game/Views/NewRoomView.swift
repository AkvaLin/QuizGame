//
//  NewRoomView.swift
//  Quiz game
//
//  Created by Никита Пивоваров on 03.11.2022.
//

import SwiftUI

struct NewRoomView: View {
    
    @ObservedObject var viewModel: ViewModel
    @Binding var isNewRoomViewShowing: Bool
    @State var name = ""
    @State var fileContent = ""
    @State var showDocumentPicker: Bool = false
    @State var showNewQuizView: Bool = false
    @State var quiz: QuizModel? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Название комнаты")
                    .padding()
                
                TextField("Название", text: $name)
                    .textFieldStyle(.roundedBorder)
                .padding()
                
                if let quizs = viewModel.quizModel,
                    quizs.count > 0 {
                    Text("Выбрать викторину")
                        .padding()
                    
                    List {
                        ForEach(quizs) { quiz in
                            HStack {
                                Text(quiz.name!)
                                Spacer()
                                Text(quiz.questionsAmount ?? "")
                            }
                            .onTapGesture {
                                self.quiz = quiz
                                showNewQuizView = true
                            }
                        }
                    }
                    .listStyle(.plain)
                    .frame(width: 300, height: 300)
                    .padding()
                }
                
                HStack {
                    Button("Создать викторину") {
                        quiz = nil
                        showNewQuizView = true
                    }
                    .buttonStyle(.bordered)
                    .padding()
                    .frame(height: 50)
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.gray.opacity(0.2))
                        .overlay {
                            Image(systemName: "folder")
                                .foregroundColor(.accentColor)
                        }
                        .frame(width: 50, height: 50)
                        .onTapGesture {
                            showDocumentPicker = true
                        }
                }
                .padding()
                
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: 320, height: 50)
                    .padding()
                    .overlay {
                        Text("Начать игру")
                        .padding()
                        .foregroundColor(.white)
                    }
                    .foregroundColor(Color.accentColor)
                    .onTapGesture {
                        
                    }
            }
            .navigationTitle("Создать комнату")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Image(systemName: "chevron.backward")
                        .onTapGesture {
                            isNewRoomViewShowing = false
                        }
                        .foregroundColor(Color.accentColor)
                }
            }
        }
        .sheet(isPresented: $showDocumentPicker) {
            DocumentPicker(fileContent: $fileContent)
        }
        .sheet(isPresented: $showNewQuizView) {
            if let quiz = self.quiz {
                NewQuizView(quizModel: quiz)
            } else {
                NewQuizView(quizModel: QuizModel())
            }
        }
    }
}

struct NewRoomView_Preview: PreviewProvider {
    static var previews: some View {
        NewRoomView(viewModel: ViewModel(), isNewRoomViewShowing: .constant(true))
    }
}
