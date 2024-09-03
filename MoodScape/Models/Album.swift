//
//  Album.swift
//  MoodScape
//
//

import Foundation

struct Album: Codable {
    let name: String
    let artist: String
    let imageUrl: String
    let spotifyUrl: String
    let releaseDate: String
    var topSongs: [Song]
    let id: String
}
