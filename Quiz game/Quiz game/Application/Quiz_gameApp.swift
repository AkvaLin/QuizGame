//
//  Quiz_gameApp.swift
//  Quiz game
//
//  Created by Никита Пивоваров on 11.09.2022.
//

import SwiftUI

@main
struct Quiz_gameApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: ViewModel())
        }
    }
}
