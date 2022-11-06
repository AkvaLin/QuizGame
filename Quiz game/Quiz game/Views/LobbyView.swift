//
//  LobbyView.swift
//  Quiz game
//
//  Created by Никита Пивоваров on 03.11.2022.
//

import SwiftUI

struct LobbyView: View {
    
    @Binding var isHost: Bool
    @ObservedObject var server: RoomModel
    @Binding var showView: Bool
    @State var showQuestionView: Bool = false
    
    var models = [
        PlayerModel(name: "Name"),
        PlayerModel(name: "Name"),
        PlayerModel(name: "Name"),
        PlayerModel(name: "Name"),
        PlayerModel(name: "Name"),
        PlayerModel(name: "Name"),
    ]
    
    var body: some View {
        
        VStack {
            List {
                ForEach(models) { model in
                    HStack {
                        Circle()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.gray.opacity(0.2))
                            .overlay {
                                Image(systemName: "person")
                                    .padding()
                            }
                            .padding([.trailing])
                        Text(model.name)
                    }
                }
            }
            
            if isHost {
                Button {
                    showQuestionView = true
                } label: {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text("Начать игру")
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
        .navigationTitle(server.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Text("\(server.playersAmount)/\(server.maxPlayersAmount)")
            }
        }
        .fullScreenCover(isPresented: $showQuestionView) {
            QuestionView(showView: $showView, showQuestionView: $showQuestionView)
        }
    }
    
}

struct LobbyView_Previews: PreviewProvider {
    static var previews: some View {
        LobbyView(isHost: .constant(true), server: .init(name: "Server", address: "12", playersAmount: 16, maxPlayersAmount: 20), showView: .constant(false))
    }
}
