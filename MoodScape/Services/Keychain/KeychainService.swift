//
//  KeychainService.swift
//  MoodScape
//
//  Created by Olga Batiunia on 10.09.24.
//

import Security
import SwiftKeychainWrapper

class KeychainService {
    static let shared = KeychainService()
    
    private let accessTokenKey = "spotifyAccessToken"
    
    func saveAccessToken(_ token: String) {
        let data = token.data(using: .utf8)!
        KeychainWrapper.standard.set(data, forKey: accessTokenKey)
    }
    
    func getAccessToken() -> String? {
        guard let data = KeychainWrapper.standard.data(forKey: accessTokenKey) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    func deleteAccessToken() {
        KeychainWrapper.standard.removeObject(forKey: accessTokenKey)
    }
}

