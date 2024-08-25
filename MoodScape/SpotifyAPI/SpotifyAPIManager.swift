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
    
    // - MARK: FetchRecentlyPublishedAlbums
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
    
    // - MARK: FetchTopSongsForAlbum
    func fetchTopSongsForAlbum(albumId: String, completion: @escaping ([Song]) -> Void) {
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
                      let artistsArray = item["artists"] as? [[String: Any]],
                      let artist = artistsArray.first?["name"] as? String,
                      let durationMs = item["duration_ms"] as? Int,
                      let spotifyUrl = item["external_urls"] as? [String: String] else {
                    return nil
                }
                let duration = self.formatDuration(durationMs: durationMs)
                return Song(name: name, artist: artist, duration: duration, spotifyUrl: spotifyUrl["spotify"]!)
            }
            completion(songs)
        }
        task.resume()
    }
    
    // - MARK: FetchWeeklyTopSongs
    func fetchWeeklyTopSongs(completion: @escaping ([Song]?) -> Void) {
        guard let accessToken = SpotifyAuthenticationManager.shared.accessToken else {
            completion([])
            return
        }
        
        guard let url = URL(string: "https://api.spotify.com/v1/playlists/37i9dQZF1DXcBWIGoYBM5M/tracks") else {
            completion(nil)
            return
        }
        var request = URLRequest(url: url)
        
        
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to fetch songs: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let response = try jsonDecoder.decode(SpotifyPlaylistResponse.self, from: data)
                
                let songs = response.items.compactMap { item -> Song? in
                    guard let track = item.track else { return nil }
                    let artistName = track.artists.first?.name ?? "Unknown Artist"
                    return Song(
                        name: track.name,
                        artist: artistName,
                        duration: "0",
                        spotifyUrl: track.external_urls["spotify"] ?? ""
                    )
                }
                completion(songs)
            } catch {
                print("Failed to parse JSON: \(error.localizedDescription)")
                completion(nil)
            }
        }
        task.resume()
    }
    
    func fetchArtistsByGenre(for genre: String, completion: @escaping ([Artist]?) -> Void) {
        guard let accessToken = SpotifyAuthenticationManager.shared.accessToken else {
            completion([])
            print("Unable to get the access token")
            return
        }
        
        let encodedGenre = genre.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? genre
        print(encodedGenre)
        let urlString = "https://api.spotify.com/v1/search?q=genre:\(encodedGenre)&type=artist&limit=50"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            print("Invalid url")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching artists: \(error)")
                completion(nil)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                completion(nil)
                return
            }
            print("HTTP Status Code: \(httpResponse.statusCode)")
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("HTTP Error: \(httpResponse.statusCode)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let artistsData = json["artists"] as? [String: Any],
                   
                   let items = artistsData["items"] as? [[String: Any]] {
                    print("\(items) pooop")
                    let artists = items.compactMap { item -> Artist? in
                        guard let name = item["name"] as? String,
                              let images = item["images"] as? [[String: Any]],
                              let imageURLString = images.first?["url"] as? String,
                              let imageURL = URL(string: imageURLString) else { return nil}
                              //let id = item["id"] as? String else { return nil }
                        return Artist(name: name, imageURL: imageURL)
                    }
                    print("Successfully fetched \(artists.count) artists")
                    completion(artists)
                } else {
                    print("Unexpected JSON structure")
                    completion(nil)
                }
            } catch {
                print("Error parsing JSON: \(error)")
                completion(nil)
            }
        }.resume()
    }
    
    // - MARK: FormatDuration
    private func formatDuration(durationMs: Int) -> String {
        let minutes = durationMs / 60000
        let seconds = (durationMs % 60000) / 1000
        return String(format: "%d:%02d", minutes, seconds)
    }
}
    
struct SpotifyPlaylistResponse: Codable {
    let items: [SpotifyTrackItem]
}

struct SpotifyTrackItem: Codable {
    let track: SpotifyTrack?
}

struct SpotifyTrack: Codable {
    let name: String
    let artists: [SpotifyArtist]
    let external_urls: [String: String]
}

struct SpotifyArtist: Codable {
    let name: String
}
