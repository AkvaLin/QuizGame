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
    @State var playersAmount: Int = 2
    @State var choosedQuiz: QuizModel?
    
    private let playersAmountArr = Array(2...20)
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Название комнаты")
                    .padding()
                
                TextField("Название", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                
                HStack {
                    Text("Максимальное количество игроков")
                    
                    Picker("Количество мест", selection: $playersAmount) {
                        ForEach(playersAmountArr, id: \.self) { amount in
                            Text("\(amount)")
                        }
                    }
                }
                
                if viewModel.quizModel.count > 0 {
                    HStack {
                        Text("Выбрать викторину")
                            .padding()
                        Picker("", selection: $choosedQuiz) {
                            ForEach(viewModel.quizModel, id: \.self) { quiz in
                                Text("\(quiz.name)").tag(quiz as QuizModel?)
                            }
                        }
                    }
                    .onAppear {
                        choosedQuiz = viewModel.quizModel.last
                    }
                    .onDisappear {
                        choosedQuiz = nil
                    }
                    
                    List {
                        ForEach(viewModel.quizModel) { quiz in
                            Button {
                                self.quiz = quiz
                                showNewQuizView = true
                            } label: {
                                HStack {
                                    Text(quiz.name)
                                    Spacer()
                                    Text("\(quiz.questionsModel.count)")
                                }
                            }
                        }
                        .onDelete(perform: delete)
                    }
                    .listStyle(.plain)
                    .padding()
                    .toolbar {
                        EditButton()
                    }
                }
                
                HStack(spacing: 20) {
                    Button("Создать викторину") {
                        quiz = nil
                        showNewQuizView = true
                    }
                    .buttonStyle(.bordered)
                    
// MARK:  documnetPicker (not work yet)
//                    Button {
//                        showDocumentPicker = true
//                    } label: {
//                        Image(systemName: "folder")
//                    }
//                    .buttonStyle(.bordered)
                }
                .padding()
                
                if choosedQuiz != nil {
                    Button {
                        viewModel.showLobbyView = true
                        let model = RoomModel(name: name, maxPlayersAmount: playersAmount, endPoint: nil)
                        viewModel.currentRoom = model
                        viewModel.setQuestions(quizModel: choosedQuiz!)
                        viewModel.startServer(name: name)
                    } label: {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Text("Создать")
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
            .navigationTitle("Создать комнату")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        isNewRoomViewShowing = false
                    } label: {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(Color.accentColor)
                    }
                }
            }
        }
        .sheet(isPresented: $showDocumentPicker) {
            DocumentPicker(fileContent: $fileContent)
        }
        .sheet(isPresented: $showNewQuizView) {
            if let quiz = self.quiz {
                NewQuizView(quizModel: quiz, viewModel: viewModel, showView: $showNewQuizView)
            } else {
                NewQuizView(quizModel: QuizModel(name: ""), viewModel: viewModel, showView: $showNewQuizView)
            }
        }
        .fullScreenCover(isPresented: $viewModel.showLobbyView) {
            NavigationView {
                LobbyView(isHost: .constant(true),
                          viewModel: viewModel,
                          roomModel: viewModel.currentRoom!,
                          showView: $viewModel.showLobbyView, isAlertPresented: .constant(false)
                )
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button {
                            viewModel.showLobbyView = false
                            viewModel.stopServer()
                        } label: {
                            Image(systemName: "chevron.backward")
                                .foregroundColor(Color.accentColor)
                        }
                    }
                }
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        viewModel.quizModel.remove(atOffsets: offsets)
    }
}

struct NewRoomView_Preview: PreviewProvider {
    static var previews: some View {
        NewRoomView(viewModel: ViewModel(), isNewRoomViewShowing: .constant(true))
    }
}
