//
//  Album.swift
//  MoodScape
//
//

import Foundation

struct Album {
    let name: String
    let artist: String
    let imageUrl: String
    let spotifyUrl: String
    let releaseDate: String
    var topSongs: [Song]
}

struct Song {
    let name: String
    let duration: String
}
