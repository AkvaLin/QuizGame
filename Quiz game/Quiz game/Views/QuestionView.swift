//
//  QuestionView.swift
//  Quiz game
//
//  Created by Никита Пивоваров on 03.11.2022.
//

import SwiftUI

struct QuestionView: View {
    
    @State var firstButtonTitle: String = "Button1"
    @State var secondButtonTitle: String = "Button2"
    @State var thirdButtonTitle: String = "Button3"
    @State var fourthButtonTitle: String = "Button4"
    @State var questionAmount: Int = 20
    @State var currentQuestion: Int = 1
    @State var showAlert = false
    @Binding var showView: Bool
    @Binding var showQuestionView: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundColor(.gray.opacity(0.25))
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
                                .frame(width: geo.size.width * CGFloat(Float(currentQuestion) / Float(questionAmount)))
                            }
                        }
                        .frame(height: 25)
                    Text("\(currentQuestion)/\(questionAmount)")
                }
                .padding(.top, 1.0)
                .padding([.leading, .trailing, .bottom])
                
                HStack(spacing: 20) {
                    VStack(spacing: 20) {
                        Button {
                            withAnimation(.easeInOut) {
                                if questionAmount > currentQuestion {
                                    currentQuestion += 1
                                }
                            }
                        } label: {
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Text(firstButtonTitle)
                                    Spacer()
                                }
                                Spacer()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.roundedRectangle(radius: 15))
                        
                        
                        Button {
                            withAnimation(.easeInOut) {
                                if questionAmount > currentQuestion {
                                    currentQuestion += 1
                                }
                            }
                        } label: {
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Text(firstButtonTitle)
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
                                if questionAmount > currentQuestion {
                                    currentQuestion += 1
                                }
                            }
                        } label: {
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Text(secondButtonTitle)
                                    Spacer()
                                }
                                Spacer()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.roundedRectangle(radius: 15))
                        
                        
                        Button {
                            withAnimation(.easeInOut) {
                                if questionAmount > currentQuestion {
                                    currentQuestion += 1
                                }
                            }
                        } label: {
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Text(fourthButtonTitle)
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
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "x.circle")
                        .onTapGesture {
                            showAlert = true
                        }
                }
            }
            .alert("Вы действительно хоитите выйти из игры?", isPresented: $showAlert) {
                Button("Да", role: .destructive) {
                    showView = false
                    showQuestionView = false
                }
                Button("Нет", role: .cancel) {
                    
                }
            }
        }
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView(showView: .constant(false), showQuestionView: .constant(true))
    }
}
