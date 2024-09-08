//
//  SpofityAuthenticationManager.swift
//  MoodScape
//
//

import Foundation
import CommonCrypto

class SpotifyAuthenticationManager {
    static let shared = SpotifyAuthenticationManager()
    private let clientID = "5856839422f94b58b4f7cd12c84b3347"
    private let clientSecret = "c10fef38a24e401ca87e3a362d7b68e0"
    private let tokenURL = "https://accounts.spotify.com/api/token"
    private let redirectURI = "moodscape://spotify-login"
    private let scopes = "user-read-private"
    
    var accessToken: String?
    
    func getAuthorizationURL() -> URL? {
        let base = "https://accounts.spotify.com/authorize"
        let authURL = "\(base)?client_id=\(clientID)&response_type=code&redirect_uri=\(redirectURI)&scope=\(scopes)"
        return URL(string: authURL)
    }
    
    func authenticate(completion: @escaping (Bool) -> Void) {
        let authString = "\(clientID):\(clientSecret)"
        guard let authData = authString.data(using: .utf8)?.base64EncodedString() else {
            completion(false)
            return
        }
            
        var request = URLRequest(url: URL(string: tokenURL)!)
        request.httpMethod = "POST"
        request.setValue("Basic \(authData)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let bodyStr = "grant_type=client_credentials"
        request.httpBody = bodyStr.data(using: .utf8)
            
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let data = data, error == nil,
                    let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                    let token = json["access_token"] as? String else {
                        completion(false)
                        return
                    }
            
            self?.accessToken = token
            completion(true)
        }
            
        task.resume()
    }
    
    func exchangeCodeForAccessToken(code: String, completion: @escaping (Bool) -> Void) {
        let tokenURL = "https://accounts.spotify.com/api/token"
        let clientID = "your-client-id"
        let clientSecret = "your-client-secret"
        let redirectURI = "your-redirect-uri"

        var request = URLRequest(url: URL(string: tokenURL)!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let bodyParams = "grant_type=authorization_code&code=\(code)&redirect_uri=\(redirectURI)&client_id=\(clientID)&client_secret=\(clientSecret)"
        request.httpBody = bodyParams.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let accessToken = json["access_token"] as? String {
                    self.accessToken = accessToken
                    completion(true)
                } else {
                    completion(false)
                }
            } catch {
                completion(false)
            }
        }
        
        task.resume()
    }
}
