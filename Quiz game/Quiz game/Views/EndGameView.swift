//
//  EndGameView.swift
//  Quiz game
//
//  Created by Никита Пивоваров on 03.11.2022.
//

import SwiftUI

struct EndGameView: View {
    
    @State var results: [ResultsModel]
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(results.sorted()) { result in
                    HStack {
                        Text(result.playerName)
                            .padding()
                        Spacer()
                        Text("\(result.playerScore)")
                            .padding()
                    }
                }
            }
            .navigationTitle("Результаты игры")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "x.circle")
                        .onTapGesture {
                            viewModel.showQuestionView = false
                            viewModel.showResultsView = false
                        }
                }
            }
        }
    }
}

struct EndGameView_Previews: PreviewProvider {
    static var previews: some View {
        EndGameView(results: [ResultsModel(playerName: "Player 1", playerScore: 0),
                              ResultsModel(playerName: "Player 2", playerScore: 5),
                              ResultsModel(playerName: "Player 3", playerScore: 2)
                             ], viewModel: ViewModel())
    }
}
