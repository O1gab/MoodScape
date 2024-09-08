//
//  SpofityAuthenticationManager.swift
//  MoodScape
//
//

import Foundation
import CommonCrypto
import UIKit

class SpotifyAuthenticationManager {
    static let shared = SpotifyAuthenticationManager()
    
    private let clientID = "5856839422f94b58b4f7cd12c84b3347"
    private let clientSecret = "c10fef38a24e401ca87e3a362d7b68e0"
    private let tokenURL = "https://accounts.spotify.com/api/token"
    private let redirectURI = "moodscape://spotify-login"
    private let scopes = "user-read-private"
    
    private let authEndpoint = "https://accounts.spotify.com/authorize"
    
    var accessToken: String?
    
    private var codeVerifier: String?
    
    private func generateCodeVerifier() -> String {
        let length = 128
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~"
        var result = ""
        for _ in 0..<length {
            result.append(characters.randomElement()!)
        }
        return result
    }
    
    private func generateCodeChallenge(codeVerifier: String) -> String {
        guard let data = codeVerifier.data(using: .utf8) else { return "" }
        
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &digest)
        }
        
        let hash = Data(digest)
        return hash.base64EncodedString()
            .replacingOccurrences(of: "=", with: "")
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
    }
    // Get Authorization URL
    func getAuthorizationURL() -> URL? {
        codeVerifier = generateCodeVerifier()
        guard let codeVerifier = codeVerifier else { return nil }
        let codeChallenge = generateCodeChallenge(codeVerifier: codeVerifier)
        
        let authURL = "\(authEndpoint)?client_id=\(clientID)&response_type=code&redirect_uri=\(redirectURI)&scope=\(scopes)&code_challenge_method=S256&code_challenge=\(codeChallenge)"
        return URL(string: authURL)
    }
    
    // Exchange Authorization Code for Access Token
    func exchangeCodeForAccessToken(code: String, completion: @escaping (Bool) -> Void) {
        guard let codeVerifier = codeVerifier else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: URL(string: tokenURL)!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let bodyParams = [
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": redirectURI,
            "client_id": clientID,
            "code_verifier": codeVerifier
        ]
        
        let bodyStr = bodyParams.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        request.httpBody = bodyStr.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let accessToken = json["access_token"] as? String {
                    self?.accessToken = accessToken
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
    
    // Initiate Authentication
    func authenticateUser(completion: @escaping (Bool) -> Void) {
        guard let authURL = getAuthorizationURL() else {
            completion(false)
            return
        }
        
        // Open Spotify authorization URL in browser
        UIApplication.shared.open(authURL) { success in
            completion(success)
        }
    }
}
