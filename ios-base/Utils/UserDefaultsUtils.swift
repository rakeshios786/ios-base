//
//  UserDefaultsUtils.swift
//  ios-base
//
//  Created by Rakesh Kumar Sharma on 27/07/20.
//  Copyright © 2020 Rootstrap Inc. All rights reserved.
//

import Foundation

extension UserDefaults {
   func save<T: Encodable>(customObject object: T, inKey key: String) {
       let encoder = JSONEncoder()
       if let encoded = try? encoder.encode(object) {
           self.set(encoded, forKey: key)
       }
   }

   func retrieve<T: Decodable>(object type: T.Type, fromKey key: String) -> T? {
       if let data = self.data(forKey: key) {
           let decoder = JSONDecoder()
           if let object = try? decoder.decode(type, from: data) {
               return object
           } else {
               RKLogger.error("Couldnt decode object")
               return nil
           }
       } else {
           RKLogger.error("Couldnt find key")
           return nil
       }
   }

}

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}


final class AppSettings: NSObject {
    static let shared = AppSettings()
    private override init() {}
    
    private enum SettingKey: String {
        case darkMode
        case emailNeedsConfirmation
    }
     
    @UserDefault(SettingKey.darkMode.rawValue, defaultValue: false)
    var darkMode: Bool
    
}
