//
//  LobbyView.swift
//  Quiz game
//
//  Created by Никита Пивоваров on 03.11.2022.
//

import SwiftUI

struct LobbyView: View {
    
    @Binding var isHost: Bool
    @ObservedObject var viewModel: ViewModel
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
        .navigationTitle(viewModel.currentRoom?.name ?? "")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Text("\(viewModel.currentRoom?.playersAmount ?? 0)/\(viewModel.currentRoom?.maxPlayersAmount ?? 0)")
            }
        }
        .fullScreenCover(isPresented: $showQuestionView) {
            QuestionView(showView: $showView, showQuestionView: $showQuestionView)
        }
    }
}
