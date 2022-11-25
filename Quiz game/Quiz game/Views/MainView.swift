//
//  MainView.swift
//  Quiz game
//
//  Created by Никита Пивоваров on 03.11.2022.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var viewModel: ViewModel
    @State var isNewRoomViewShowing: Bool = false
    @State var showPersonAlert: Bool = false
    
    @State var name: String = UserDefaults.standard.string(forKey: "playerName") ?? "Player"
    
    var body: some View {
        NavigationView {
            VStack {
                if let rooms = viewModel.roomModel {
                    List {
                        ForEach(rooms) { room in
                            NavigationLink(destination: LobbyView(isHost: .constant(false),
                                                                  viewModel: viewModel,
                                                                  roomModel: room,
                                                                  showView: $viewModel.showLobbyView, isAlertPresented: $viewModel.alertError)
                                .onAppear {
                                    guard let endPoint = room.endPoint else { return }
                                    viewModel.startConnection(endPoint: endPoint)
                                    viewModel.currentRoom = room
                                }
                                .onDisappear {
                                    viewModel.cancelConnection()
                                }
                            ) {
                                HStack {
                                    Circle()
                                        .frame(width: 45, height: 45)
                                        .foregroundColor(Color.gray.opacity(0.5))
                                        .overlay {
                                            Image(systemName: "person.3.fill")
                                                .foregroundColor(.black)
                                        }
                                    VStack(alignment: .leading, spacing: 7) {
                                        Text(room.name)
                                            .font(Font.system(size: 17))
                                            .lineLimit(2)
                                    }
                                    .padding([.leading, .trailing])
                                }
                            }
                        }
                    }
                }
                
                Button {
                    isNewRoomViewShowing = true
                } label: {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text("Создать комнату")
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
            .navigationTitle("Quiz Game")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showPersonAlert = true
                    } label: {
                        Image(systemName: "person")
                    }
                }
            }
            .fullScreenCover(isPresented: $isNewRoomViewShowing) {
                NewRoomView(viewModel: viewModel, isNewRoomViewShowing: $isNewRoomViewShowing)
            }
            .alert("Введите имя", isPresented: $showPersonAlert) {
                TextField("Name", text: $name)
                Button("Сохранить") {
                    UserDefaults.standard.set(name, forKey: "playerName")
                }
                Button("Отмена", role: .cancel) {
                    name = UserDefaults.standard.string(forKey: "playerName") ?? "Player"
                }
            }
        }
        .onAppear {
            viewModel.startBrowsing()
        }
        .onDisappear {
            viewModel.cancelBrowsing()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: ViewModel())
    }
}
