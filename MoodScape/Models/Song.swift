//
//  Song.swift
//  MoodScape
//
//  Created by Olga Batiunia on 26.08.24.
//

import Foundation

struct Song: Codable {
    let name: String
    let artist: String
    let duration: String
    let spotifyUrl: String
    let releaseDate: String
    let imageUrl: String?
}
