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
                    let album = Album(name: name, artist: artistName, imageUrl: imageUrl, spotifyUrl: spotifyUrl["spotify"]!, releaseDate: releaseDate, topSongs: songs, id: albumId)
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
                      let spotifyUrl = item["external_urls"] as? [String: String],
                      let imageURLString = "" as? String else {
                    return nil
                }
                let duration = self.formatDuration(durationMs: durationMs)
                return Song(name: name, id: "", artist: artist, duration: duration, spotifyUrl: spotifyUrl["spotify"]!, releaseDate: "", imageUrl: imageURLString)
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
                    let id = ""
                    return Song(
                        name: track.name,
                        id: id,
                        artist: artistName,
                        duration: "0",
                        spotifyUrl: track.external_urls["spotify"] ?? "",
                        releaseDate: "",
                        imageUrl: ""
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
    
    // - MARK: FetchArtistsByGenre (used during registration)
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
                    let artists = items.compactMap { item -> Artist? in
                        guard let name = item["name"] as? String,
                              let images = item["images"] as? [[String: Any]],
                              let imageURLString = images.first?["url"] as? String,
                              let imageURL = URL(string: imageURLString),
                              let id = item["id"] as? String else { return nil }
                        return Artist(name: name, id: id, imageURL: imageURL, imageURLString: imageURLString)
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
    
    // - MARK: FetchSimilarArtists (used during registration)
    func fetchSimilarArtists(for artist: Artist, completion: @escaping ([Artist]?) -> Void) {
        guard let authToken = SpotifyAuthenticationManager.shared.accessToken else {
            completion([])
            print("Unable to get the access token")
            return
        }
        
        let urlString = "https://api.spotify.com/v1/artists/\(artist.id)/related-artists"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching similar artists: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let artistsData = json["artists"] as? [[String: Any]] {
                    let similarArtists = artistsData.compactMap { item -> Artist? in
                        guard let name = item["name"] as? String,
                              let images = item["images"] as? [[String: Any]],
                              let imageURLString = images.first?["url"] as? String,
                              let imageURL = URL(string: imageURLString),
                              let id = item["id"] as? String else { return nil }
                        return Artist(name: name, id: id, imageURL: imageURL, imageURLString: imageURLString)
                    }
                    completion(similarArtists)
                } else {
                    completion(nil)
                }
            } catch {
                print("Error parsing similar artists JSON: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
    
    private let baseURL = "https://api.spotify.com/v1/"
    
    func fetchArtistID(for artistName: String, completion: @escaping (String?) -> Void) {
        guard let authToken = SpotifyAuthenticationManager.shared.accessToken else {
            completion(nil)
            return
        }
        
        let encodedArtistName = artistName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(baseURL)search?q=\(encodedArtistName)&type=artist&limit=1"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching artist ID for \(artistName): \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data returned for artist \(artistName)")
                completion(nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let artistsData = json["artists"] as? [String: Any],
                   let items = artistsData["items"] as? [[String: Any]],
                   let artist = items.first,
                   let id = artist["id"] as? String {
                    completion(id)
                } else {
                    print("Error parsing JSON for artist \(artistName)")
                    completion(nil)
                }
            } catch {
                print("Error parsing JSON for artist \(artistName): \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
    
    func fetchTopTracks(for artistID: String, completion: @escaping ([Song]?) -> Void) {
        guard let authToken = SpotifyAuthenticationManager.shared.accessToken else {
            completion(nil)
            return
        }
        
        let urlString = "\(baseURL)artists/\(artistID)/top-tracks?market=US"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching top tracks for artist \(artistID): \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data returned for artist \(artistID)")
                completion(nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let tracksData = json["tracks"] as? [[String: Any]] {
                    let tracks = tracksData.compactMap { item -> Song? in
                        guard let name = item["name"] as? String,
                              let artists = item["artists"] as? [[String: Any]],
                              let artistName = artists.first?["name"] as? String,
                              let id = item["id"] as? String,
                              let album = item["album"] as? [String: Any],
                              let images = album["images"] as? [[String: Any]],
                              let imageURLString = images.first?["url"] as? String,
                              let releaseDate = album["release_date"] as? String else {
                            print("Error parsing track item: \(item)")
                            return nil
                        }
                        return Song(name: name, id: id, artist: artistName, duration: "", spotifyUrl: "", releaseDate: releaseDate, imageUrl: imageURLString)
                    }
                    completion(tracks)
                } else {
                    print("Error parsing JSON for artist \(artistID)")
                    completion(nil)
                }
            } catch {
                print("Error parsing JSON for artist \(artistID): \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
    
    func fetchArtistDetails(for artistID: String, completion: @escaping (Artist?) -> Void) {
        guard let authToken = SpotifyAuthenticationManager.shared.accessToken else {
            completion(nil)
            return
        }
        
        let urlString = "\(baseURL)artists/\(artistID)"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching artist details for artist \(artistID): \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data returned for artist \(artistID)")
                completion(nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    let name = json["name"] as? String ?? ""
                    let popularity = json["popularity"] as? Int ?? 0
                    if let images = json["images"] as? [[String: Any]],
                       let imageURLString = images.first?["url"] as? String,
                       let imageURL = URL(string: imageURLString) {
                        let artist = Artist(
                            name: name,
                            id: artistID,
                            imageURL: imageURL,
                            imageURLString: imageURLString
                        )
                        completion(artist)
                    } else {
                        print("Error parsing images for artist \(artistID)")
                        completion(nil)
                    }
                } else {
                    print("Error parsing JSON for artist \(artistID)")
                    completion(nil)
                }
            } catch {
                print("Error parsing JSON for artist \(artistID): \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
    
    func createPlaylist(name: String, userId: String, completion: @escaping (String?) -> Void) {
        guard let accessToken = SpotifyAuth.shared.accessToken else {
            print("No access token available")
            completion(nil)
            return
        }

        // Define the API endpoint
        let url = URL(string: "https://api.spotify.com/v1/users/\(userId)/playlists")!
        
        // Set up the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create the body for the playlist
        let playlistData: [String: Any] = [
            "name": name,
            "description": "Generated by MoodScape",
            "public": false
        ]
        
        // Convert to JSON
        guard let jsonData = try? JSONSerialization.data(withJSONObject: playlistData, options: []) else {
            completion(nil)
            return
        }
        request.httpBody = jsonData
        
        // Create the task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error creating playlist: \(error)")
                completion(nil)
                return
            }
            
            if let data = data, let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 201 {
                    do {
                        // Parse the response
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        let playlistId = json?["id"] as? String
                        completion(playlistId)
                    } catch {
                        print("Error parsing response: \(error)")
                        completion(nil)
                    }
                } else {
                    print("Failed to create playlist. Status code: \(httpResponse.statusCode)")
                    if let responseData = String(data: data, encoding: .utf8) {
                        print("Raw API Response: \(responseData)")
                    }
                    completion(nil)
                }
            }
        }
        
        task.resume()
    }
    
    func addTracksToPlaylist(playlistID: String, trackURIs: [String], completion: @escaping (Bool) -> Void) {
        guard let accessToken = SpotifyAuth.shared.accessToken else {
            print("No access token available")
            completion(false)
            return
        }
        
        let url = URL(string: "https://api.spotify.com/v1/playlists/\(playlistID)/tracks")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let jsonBody: [String: Any] = ["uris": trackURIs]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonBody, options: .prettyPrinted)
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard data != nil, error == nil else {
                    print("Failed to add tracks: \(error?.localizedDescription ?? "Unknown error")")
                    completion(false)
                    return
                }
                completion(true)
            }
            task.resume()
        } catch {
            print("Error serializing track data: \(error.localizedDescription)")
            completion(false)
        }
    }

    func searchForTrack(artist: String, song: String, completion: @escaping (Song?) -> Void) {
        guard let accessToken = SpotifyAuth.shared.accessToken else {
            print("No access token available")
            completion(nil)
            return
        }
        
        // Build the search query
        let query = "\(song) artist:\(artist)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.spotify.com/v1/search?q=\(query)&type=track&limit=1"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to search for track: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let tracks = json["tracks"] as? [String: Any],
                   let items = tracks["items"] as? [[String: Any]],
                   let firstItem = items.first {
                    
                    // Log the full first item to debug
                    print("First track item: \(firstItem)")
                    
                    // Extract song details
                    if let name = firstItem["name"] as? String,
                       let id = firstItem["id"] as? String,
                       let artists = firstItem["artists"] as? [[String: Any]],
                       let artist = artists.first?["name"] as? String,
                       let duration = firstItem["duration_ms"] as? Int,
                       let externalUrls = firstItem["external_urls"] as? [String: String],
                       let spotifyUrl = externalUrls["spotify"] {
                        
                        // Ensure spotifyUrl is correctly assigned and not "N/A"
                        print("Extracted Spotify URL: \(spotifyUrl)")
                        
                        let album = firstItem["album"] as? [String: Any]
                        let releaseDate = album?["release_date"] as? String ?? "N/A"
                        let images = album?["images"] as? [[String: Any]]
                        let imageUrl = images?.first?["url"] as? String
                        
                        // Create a Song object
                        let song = Song(name: name, id: id, artist: artist, duration: "\(duration / 1000) seconds", spotifyUrl: spotifyUrl, releaseDate: releaseDate, imageUrl: imageUrl)
                        completion(song)
                    } else {
                        print("Failed to extract all song details")
                        completion(nil)
                    }
                } else {
                    print("No tracks found for query")
                    completion(nil)
                }
            } catch {
                print("Error parsing search result: \(error.localizedDescription)")
                completion(nil)
            }
        }
        task.resume()
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
