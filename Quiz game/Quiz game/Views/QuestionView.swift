//
//  QuestionView.swift
//  Quiz game
//
//  Created by Никита Пивоваров on 03.11.2022.
//

import SwiftUI

struct QuestionView: View {
    
    @ObservedObject var viewModel: ViewModel
    @ObservedObject var questionModel: QuestionModel
    @State var showAlert: Bool = false
    @Binding var showView: Bool
    @Binding var showQuestionView: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundColor(.gray.opacity(0.25))
                        .overlay {
                            Text(questionModel.question)
                                .padding()
                                .multilineTextAlignment(.center)
                                .lineLimit(8)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding()
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundColor(.gray.opacity(0.25))
                        .overlay {
                            GeometryReader { geo in
                                RoundedRectangle(cornerRadius: 25)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.blueBright.opacity(0.6), Color.blueDark.opacity(0.6)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: geo.size.width * CGFloat(Float(questionModel.questionsAmount[0]) / Float(questionModel.questionsAmount[1])))
                            }
                        }
                        .frame(height: 25)
                    Text("\(questionModel.questionsAmount[0])/\(questionModel.questionsAmount[1])")
                }
                .padding(.top, 1.0)
                .padding([.leading, .trailing, .bottom])
                
                if questionModel.showButtons {
                    HStack(spacing: 20) {
                        VStack(spacing: 20) {
                            Button {
                                withAnimation(.easeInOut) {
                                    questionModel.showButtons = false
                                    viewModel.sendAnswer(answer: questionModel.firstAnswer == questionModel.answer)
                                }
                            } label: {
                                VStack {
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        Text(questionModel.firstAnswer)
                                        Spacer()
                                    }
                                    Spacer()
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .buttonBorderShape(.roundedRectangle(radius: 15))
                            
                            
                            Button {
                                withAnimation(.easeInOut) {
                                    questionModel.showButtons = false
                                    viewModel.sendAnswer(answer: questionModel.thirdAnswer == questionModel.answer)
                                }
                            } label: {
                                VStack {
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        Text(questionModel.thirdAnswer)
                                        Spacer()
                                    }
                                    Spacer()
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .buttonBorderShape(.roundedRectangle(radius: 15))
                            
                        }
                        VStack(spacing: 20) {
                            Button {
                                withAnimation(.easeInOut) {
                                    questionModel.showButtons = false
                                    viewModel.sendAnswer(answer: questionModel.secondAnswer == questionModel.answer)
                                }
                            } label: {
                                VStack {
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        Text(questionModel.secondAnswer)
                                        Spacer()
                                    }
                                    Spacer()
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .buttonBorderShape(.roundedRectangle(radius: 15))
                            
                            Button {
                                withAnimation(.easeInOut) {
                                    viewModel.sendAnswer(answer: questionModel.fourthAnswer == questionModel.answer)
                                    questionModel.showButtons = false
                                }
                            } label: {
                                VStack {
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        Text(questionModel.fourthAnswer)
                                        Spacer()
                                    }
                                    Spacer()
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .buttonBorderShape(.roundedRectangle(radius: 15))
                            
                        }
                    }
                    .padding()
                } else {
                    Text("Ожидание следующего вопроса...")
                        .padding()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "x.circle")
                        .onTapGesture {
                            showAlert = true
                        }
                }
            }
            .alert("Вы действительно хоитите завершить игру?", isPresented: $showAlert) {
                Button("Да", role: .destructive) {
                    showView = false
                    showQuestionView = false
                    viewModel.cancelTimer()
                    viewModel.stopServer()
                    viewModel.cancelConnection()
                }
                Button("Нет", role: .cancel) { }
            }
            .fullScreenCover(isPresented: $viewModel.showResultsView) {
                EndGameView(results: viewModel.results, viewModel: viewModel)
            }
        }
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView(viewModel: ViewModel(), questionModel: QuestionModel(questionsAmount: [2,10]), showView: .constant(true), showQuestionView: .constant(true))
    }
}
