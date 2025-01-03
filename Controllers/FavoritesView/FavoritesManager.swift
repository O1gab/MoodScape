//
//  FavoritesManager.swift
//  MoodScape
//
//  Created by Olga Batiunia on 03.09.24.
//

import Foundation

class FavoritesManager {
    
    private let albumsKey = "favoriteAlbums"
    private let songsKey = "favoriteSongs"
    
    static let shared = FavoritesManager()
    
    init() {}
    
    func addFavoriteAlbum(_ album: Album) {
        var favorites = getFavoriteAlbums()
        if !favorites.contains(where: { $0.id == album.id }) {
            favorites.append(album)
            saveFavoriteAlbums(favorites)
        }
    }
    
    func removeFavoriteAlbum(_ album: Album) {
        var favorites = getFavoriteAlbums()
        if let index = favorites.firstIndex(where: { $0.id == album.id }) {
            favorites.remove(at: index)
            saveFavoriteAlbums(favorites)
        }
    }
    
    func isFavoriteAlbum(_ album: Album) -> Bool {
        let favorites = getFavoriteAlbums()
        return favorites.contains(where: { $0.id == album.id })
    }
    
    func addFavoriteSong(_ song: Song) {
        var favorites = getFavoriteSongs()
        if !favorites.contains(where: { $0.name == song.name && $0.artist == song.artist }) {
            favorites.append(song)
            saveFavoriteSongs(favorites)
        }
    }
    
    func removeFavoriteSong(_ song: Song) {
        var favorites = getFavoriteSongs()
        if let index = favorites.firstIndex(where: { $0.name == song.name && $0.artist == song.artist }) {
            favorites.remove(at: index)
            saveFavoriteSongs(favorites)
        }
    }
    
    func isFavoriteSong(_ song: Song) -> Bool {
        let favorites = getFavoriteSongs()
        return favorites.contains(where: { $0.name == song.name && $0.artist == song.artist })
    }
    
    private func saveFavoriteAlbums(_ favorites: [Album]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(favorites) {
            UserDefaults.standard.set(encoded, forKey: albumsKey)
        }
    }
    
   func getFavoriteAlbums() -> [Album] {
        if let savedData = UserDefaults.standard.data(forKey: albumsKey) {
            let decoder = JSONDecoder()
            if let loadedAlbums = try? decoder.decode([Album].self, from: savedData) {
                return loadedAlbums
            }
        }
        return []
    }
    
    private func saveFavoriteSongs(_ favorites: [Song]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(favorites) {
            UserDefaults.standard.set(encoded, forKey: songsKey)
        }
    }
    
    func getFavoriteSongs() -> [Song] {
        if let savedData = UserDefaults.standard.data(forKey: songsKey) {
            let decoder = JSONDecoder()
            if let loadedSongs = try? decoder.decode([Song].self, from: savedData) {
                return loadedSongs
            }
        }
        return []
    }
}
