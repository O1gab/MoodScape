//
//  User.swift
//  MoodScape
//
//  Created by Olga Batiunia on 11.08.24.
//

import Foundation

struct User {
    var profileImage: String // fix it with uiimage
    var nickname: String
    var firstName: String
    var lastName: String
    var region: String
    var registrationDate: Date
    var friends: [String]
    var recommendedPlaylists: [String]
    var musicPreferences: [String]
}
