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
    @State var showView: Bool = false
    @State var showPersonAlert: Bool = false
    
    @State var name: String = "Player"
    
    var body: some View {
        NavigationView {
            VStack {
                if let rooms = viewModel.roomModel {
                    List {
                        ForEach(rooms) { room in
                            NavigationLink(destination: LobbyView(isHost: .constant(false), server: room, showView: $showView)) {
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
                                        Text(room.address)
                                            .font(Font.system(size: 12))
                                    }
                                    .padding([.leading, .trailing])
                                    Spacer()
                                    Text("\(room.playersAmount)/\(room.maxPlayersAmount)")
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
                    
                }
                Button("Отмена", role: .cancel) {
                    
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel:
                    ViewModel(roomModel:
                                [
                                    RoomModel(name: "Test1", address: "10.10.10.10", playersAmount: 14, maxPlayersAmount: 20),
                                    RoomModel(name: "Test1", address: "10.10.10.10", playersAmount: 15, maxPlayersAmount: 15),
                                    RoomModel(name: "Test1", address: "10.10.10.10", playersAmount: 16, maxPlayersAmount: 30),
                                    RoomModel(name: "Супер Длинное названиеееееееееееееееееееееееееееееее", address: "10.10.10.10", playersAmount: 3, maxPlayersAmount: 10)
                                ]))
    }
}
