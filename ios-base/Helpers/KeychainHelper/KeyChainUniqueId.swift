//
//  KeyChainHandle.swift
//  KeychainWrapper
//
//  Created by Rakesh Kumar Sharma on 21/04/20.
//  Copyright © 2020 Rakesh Kumar Sharma. All rights reserved.
//

import Foundation

private let UUIDKey: StaticString = "UniqueIdentificationApp"

extension KeychainWrapper {
    
    @discardableResult
    open func set(_ value: String, forKey key: String) -> Bool {
        guard let value = value.data(using: .utf8) else { return false }
        
        delete(key)
        
        let query: [NSString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: value,
            kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock
        ]
        
        return SecItemAdd(query as CFDictionary, nil) == noErr
    }
    
    @discardableResult
    open func delete(_ key: String) -> Bool {
        
        let query: [NSString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ]
        
        return SecItemDelete(query as CFDictionary) == noErr
    }
    
    open func get(_ key: String) -> String? {
        
        let query: [NSString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: kCFBooleanTrue,
            kSecMatchLimit: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == noErr else { return nil }
        guard let data = result as? Data else { return nil }
        
        return String(data: data, encoding: .utf8)
    }
}

extension KeychainWrapper {
 
    /// Device unique identification
    public var UUIDString: String {
        let key = String(describing: UUIDKey)
        guard let value = get(key) else {
            let uuid = UUID().uuidString
            set(uuid, forKey: key)
            return uuid
        }
        
        return value
    }
}
