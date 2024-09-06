//
//  GroqAPIClient.swift
//  MoodScape
//
//  Created by Olga Batiunia on 06.09.24.
//

import Foundation
import Alamofire

class GroqAPIClient {
    
    private let apiKey: String
    
    init() {
        // Set the API key (replace with environment variable in production)
        self.apiKey = "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"
    }
    
    func sendPrompt(_ prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        let endpoint = "https://api.groq.com/openai/v1/chat/completions"
        
        let parameters: [String: Any] = [
            "model": "llama3-8b-8192",
            "messages": [
                ["role": "user", "content": prompt]
            ],
            "temperature": 0.5,
            "max_tokens": 500
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]
        
        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any],
                       let choices = json["choices"] as? [[String: Any]],
                       let firstChoice = choices.first,
                       let message = firstChoice["message"] as? [String: Any],
                       let content = message["content"] as? String {
                        completion(.success(content))
                    } else {
                        let parsingError = NSError(domain: "ParsingError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to parse completion text"])
                        completion(.failure(parsingError))
                    }
                case .failure(let error):
                    if let data = response.data, let errorMessage = String(data: data, encoding: .utf8) {
                        print("API Error: \(errorMessage)")
                    }
                    completion(.failure(error))
                }
            }
    }
}
