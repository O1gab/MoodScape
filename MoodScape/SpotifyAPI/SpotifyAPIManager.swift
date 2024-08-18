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
            
            let albums: [Album] = items.compactMap { item in
                guard let name = item["name"] as? String,
                      let artists = item["artists"] as? [[String: Any]],
                      let artistName = artists.first?["name"] as? String,
                      let images = item["images"] as? [[String: Any]],
                      let imageUrl = images.first?["url"] as? String,
                      let spotifyUrl = item["external_urls"] as? [String: String],
                      let releaseDate = item["release_date"] as? String
                else {
                    // let externalUrls = item["external_urls"] as? [String: String],
                    // let spotifyUrl = externalUrls["spotify"] else {
                    return nil
                }
                return Album(name: name, artist: artistName, imageUrl: imageUrl, spotifyUrl: spotifyUrl["spotify"]!, releaseDate: releaseDate)
            }
            
            completion(albums)
        }
        
        task.resume()
    }
}
