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
    @State var showView: Bool = false
    @State var playersAmount: Int = 2
    
    private let server: NetworkServer? = nil
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
                    .padding()
                }
                
                HStack(spacing: 20) {
                    Button("Создать викторину") {
                        quiz = nil
                        showNewQuizView = true
                    }
                    .buttonStyle(.bordered)
                    

                    Button {
                        showDocumentPicker = true
                    } label: {
                        Image(systemName: "folder")
                    }
                    .buttonStyle(.bordered)
                    
                }
                .padding()
                
                Button {
                    showView = true
                    let model = RoomModel(name: name, maxPlayersAmount: playersAmount, endPoint: nil)
                    viewModel.currentRoom = model
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
        .fullScreenCover(isPresented: $showView) {
            NavigationView {
                LobbyView(isHost: .constant(true),
                          viewModel: viewModel,
                          roomModel: viewModel.currentRoom!,
                          showView: $showView, isAlertPresented: .constant(false)
                )
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Image(systemName: "chevron.backward")
                                .onTapGesture {
                                    showView = false
                                    viewModel.stopServer()
                                }
                                .foregroundColor(Color.accentColor)
                        }
                    }
            }
        }
    }
}

struct NewRoomView_Preview: PreviewProvider {
    static var previews: some View {
        NewRoomView(viewModel: ViewModel(), isNewRoomViewShowing: .constant(true))
    }
}
