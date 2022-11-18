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
    @ObservedObject var roomModel: RoomModel
    @Binding var showView: Bool
    @Binding var isAlertPresented: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack {
            List {
                ForEach(roomModel.players, id: \.self) { name in
                    HStack {
                        Circle()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.gray.opacity(0.2))
                            .overlay {
                                Image(systemName: "person")
                                    .padding()
                            }
                            .padding([.trailing])
                        Text(name)
                    }
                }
            }
            
            if isHost {
                Button {
                    viewModel.showQuestionView = true
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
        .navigationTitle(roomModel.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Text("\(roomModel.playersAmount)/\(roomModel.maxPlayersAmount)")
            }
        }
        .fullScreenCover(isPresented: $viewModel.showQuestionView) {
            QuestionView(showView: $showView, showQuestionView: $viewModel.showQuestionView)
        }
        .alert("Нет свободных мест", isPresented: $isAlertPresented) {
            Button("Ok", role: .cancel) {
                dismiss()
                viewModel.cancelConnection()
            }
        }
    }
}
