//
//  Extensions.swift
//  Quiz game
//
//  Created by Никита Пивоваров on 05.11.2022.
//

import Foundation
import SwiftUI

extension Color {
    static let pinkBright = Color(red: 247/255, green: 37/255, blue: 133/255)
    static let blueBright = Color(red: 67/255, green: 97/255, blue: 238/255)
    static let blueDark = Color(red: 58/255, green: 12/255, blue: 163/255)
}

extension UserDefaults {
    private enum UserDefaultsKeys: String {
        case hasLaunched
    }
    
    var hasLaunched: Bool {
        get {
            bool(forKey: UserDefaultsKeys.hasLaunched.rawValue)
        }
        
        set {
            setValue(newValue,
                     forKey: UserDefaultsKeys.hasLaunched.rawValue)
        }
    }
}
