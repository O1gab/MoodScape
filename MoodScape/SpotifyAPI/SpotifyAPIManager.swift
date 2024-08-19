//
//  SpotifyAPIManager.swift
//  MoodScape
//
//  Created by Olga Batiunia on 16.08.24.
//

import Foundation

class SpotifyAPIManager {
    static let shared = SpotifyAPIManager()
    
    private init() {}
    
    func fetchRecentlyPublishedAlbums(completion: @escaping ([Album]?) -> Void) {
        guard let accessToken = SpotifyAuthenticationManager.shared.accessToken else {
            completion(nil)
            return
        }
        
        let url = URL(string: "https://api.spotify.com/v1/browse/new-releases?country=US")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                let albumsJson = json["albums"] as? [String: Any],
                let items = albumsJson["items"] as? [[String: Any]] else {
                completion(nil)
                return
            }
                
            var albums: [Album] = []
            let dispatchGroup = DispatchGroup()
                
            for item in items {
                dispatchGroup.enter()
                    
                guard let name = item["name"] as? String,
                    let artists = item["artists"] as? [[String: Any]],
                    let artistName = artists.first?["name"] as? String,
                    let images = item["images"] as? [[String: Any]],
                    let imageUrl = images.first?["url"] as? String,
                    let spotifyUrl = item["external_urls"] as? [String: String],
                    let releaseDate = item["release_date"] as? String,
                    let albumId = item["id"] as? String else {
                    dispatchGroup.leave()
                    continue
                }
                    
                self.fetchTopSongsForAlbum(albumId: albumId) { songs in
                    let album = Album(name: name, artist: artistName, imageUrl: imageUrl, spotifyUrl: spotifyUrl["spotify"]!, releaseDate: releaseDate, topSongs: songs)
                    albums.append(album)
                    dispatchGroup.leave()
                }
            }
                
            dispatchGroup.notify(queue: .main) {
                completion(albums)
            }
        }
            
        task.resume()
    }
    
    private func fetchTopSongsForAlbum(albumId: String, completion: @escaping ([Song]) -> Void) {
        guard let accessToken = SpotifyAuthenticationManager.shared.accessToken else {
            completion([])
            return
        }
            
        let url = URL(string: "https://api.spotify.com/v1/albums/\(albumId)/tracks")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                let items = json["items"] as? [[String: Any]] else {
                completion([])
                return
            }
                
            let songs: [Song] = items.prefix(3).compactMap { item in
                guard let name = item["name"] as? String,
                    let durationMs = item["duration_ms"] as? Int,
                    let spotifyUrl = item["spotify_url"] as? String else {
                    return nil
                }
                let duration = self.formatDuration(durationMs: durationMs)
                return Song(name: name, duration: duration, spotifyUrl: spotifyUrl)
            }
            completion(songs)
        }
        task.resume()
    }
        
    private func formatDuration(durationMs: Int) -> String {
        let minutes = durationMs / 60000
        let seconds = (durationMs % 60000) / 1000
        return String(format: "%d:%02d", minutes, seconds)
    }
}
