//
//  PlaylistStorage.swift
//  MoodScape
//
//

import UIKit

class PlaylistStorage {
    private let storageKey = "storedPlaylists"

    func savePlaylist(_ playlist: Playlist) {
        var storedPlaylists = fetchPlaylists()
        storedPlaylists.append(playlist)

        let dicts = storedPlaylists.map { playlistToDictionary($0) }
        UserDefaults.standard.set(dicts, forKey: storageKey)
    }

    func fetchPlaylists() -> [Playlist] {
        guard let savedArray = UserDefaults.standard.array(forKey: storageKey) as? [[String: Any]] else {
            return []
        }

        return savedArray.compactMap { dictionaryToPlaylist($0) }
    }

    private func playlistToDictionary(_ playlist: Playlist) -> [String: Any] {
        return [
            "id": playlist.id,
            "name": playlist.name,
            "color": playlist.color,
            "date": playlist.date,
            "emotions": playlist.emotions,
            "spotifyURL": playlist.spotifyURL.absoluteString
        ]
    }

    private func dictionaryToPlaylist(_ dict: [String: Any]) -> Playlist? {
        guard let id = dict["id"] as? String,
              let name = dict["name"] as? String,
              let color = dict["color"] as? UIColor,
              let date = dict["date"] as? String,
              let emotions = dict["emotions"] as? [String],
              let spotifyURLString = dict["spotifyURL"] as? String,
              let spotifyURL = URL(string: spotifyURLString) else {
            return nil
        }
        return Playlist(id: id, name: name, color: color, date: date, emotions: emotions, spotifyURL: spotifyURL)
    }
}

