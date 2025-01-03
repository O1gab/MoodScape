//
//  AuthResponse.swift
//  MoodScape
//
//  Created by Olga Batiunia on 11.09.24.
//

import Foundation

struct AuthResponse: Codable {
    let access_token: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
    let token_type: String
}
