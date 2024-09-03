//
//  FavoritesManager.swift
//  MoodScape
//
//  Created by Olga Batiunia on 03.09.24.
//

import UIKit

class FavoritesManager {
    private let albumsKey = "favoriteAlbums"
    private let songsKey = "favoriteSongs"
    
    static let shared = FavoritesManager()
    
    private init() {}
    
    func addFavoriteAlbum(_ album: Album) {
        var favorites = getFavoriteAlbums()
        if !favorites.contains(album.id) {
            favorites.append(album.id)
            saveFavoriteAlbums(favorites)
        }
    }
    
    func removeFavoriteAlbum(_ album: Album) {
        var favorites = getFavoriteAlbums()
        if let index = favorites.firstIndex(of: album.id) {
            favorites.remove(at: index)
            saveFavoriteAlbums(favorites)
        }
    }
    
    func isFavoriteAlbum(_ album: Album) -> Bool {
        let favorites = getFavoriteAlbums()
        return favorites.contains(album.id)
    }
    
    func addFavoriteSong(_ song: Song) {
        var favorites = getFavoriteSongs()
        if !favorites.contains(song.name) {
            favorites.append(song.name)
            saveFavoriteSongs(favorites)
        }
    }
    
    func removeFavoriteSong(_ song: Song) {
        var favorites = getFavoriteSongs()
        if let index = favorites.firstIndex(of: song.name) {
            favorites.remove(at: index)
            saveFavoriteSongs(favorites)
        }
    }
    
    func isFavoriteSong(_ song: Song) -> Bool {
        let favorites = getFavoriteSongs()
        return favorites.contains(song.name)
    }
    
    private func saveFavoriteAlbums(_ favorites: [String]) {
        UserDefaults.standard.set(favorites, forKey: albumsKey)
    }
    
    private func getFavoriteAlbums() -> [String] {
        return UserDefaults.standard.array(forKey: albumsKey) as? [String] ?? []
    }
    
    private func saveFavoriteSongs(_ favorites: [String]) {
        UserDefaults.standard.set(favorites, forKey: songsKey)
    }
    
    private func getFavoriteSongs() -> [String] {
        return UserDefaults.standard.array(forKey: songsKey) as? [String] ?? []
    }
}

