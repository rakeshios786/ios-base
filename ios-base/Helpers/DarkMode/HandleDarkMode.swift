//
//  HandleDarkMode.swift
//  Lystn
//
//  Created by Rakesh Kumar Sharma on 18/05/20.
//  Copyright © 2020 Rakesh Kumar Sharma. All rights reserved.
//

import UIKit
import FluentDarkModeKit
import Foundation

struct HandleColors {
    static let viewBackgroundColor = UIColor(.dm, light: .white, dark: .black)
}

class HandleDarkMode: NSObject {
    static let shared = HandleDarkMode()
    private override init() {}
    
    func setup() {
        DarkModeManager.setup()
        if let value = KeychainWrapper.default.string(forKey: "darkMode") {
            DMTraitCollection.current = (value == "1") ? DMTraitCollection(userInterfaceStyle: .dark) : DMTraitCollection(userInterfaceStyle: .light)
        } else {
            KeychainWrapper.default.set("1", forKey: "darkMode")
            DMTraitCollection.current = DMTraitCollection(userInterfaceStyle: .light)
        }
        
        DarkModeManager.updateAppearance(for: .shared, animated: true)
    }
    
    func tongle() {
        if let value = KeychainWrapper.default.string(forKey: "darkMode") {
            KeychainWrapper.default.set("0", forKey: "darkMode")
            DMTraitCollection.current = value == "0"  ? DMTraitCollection(userInterfaceStyle: .dark) : DMTraitCollection(userInterfaceStyle: .light)
        } else {
            DMTraitCollection.current = DMTraitCollection(userInterfaceStyle: .light)
        }
         
        DarkModeManager.updateAppearance(for: .shared, animated: true)
        
    }
    
}
