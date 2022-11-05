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
    @State var questionAmountTitle: String = "1/20"
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
                        .frame(height: 25)
                    Text(questionAmountTitle)
                }
                .padding(.top, 1.0)
                .padding([.leading, .trailing, .bottom])
                
                HStack(spacing: 40) {
                    VStack {
                        Button(firstButtonTitle) {
                            
                        }
                        .buttonStyle(.borderedProminent)
                        .padding()
                        
                        Button(thirdButtonTitle) {
                            
                        }
                        .buttonStyle(.borderedProminent)
                        .padding()
                    }
                    VStack {
                        Button(secondButtonTitle) {
                            
                        }
                        .buttonStyle(.borderedProminent)
                        .padding()
                        
                        Button(fourthButtonTitle) {
                            
                        }
                        .buttonStyle(.borderedProminent)
                        .padding()
                    }
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
