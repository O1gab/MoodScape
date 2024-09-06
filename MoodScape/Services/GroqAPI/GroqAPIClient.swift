//
//  GroqAPIClient.swift
//  MoodScape
//
//  Created by Olga Batiunia on 06.09.24.
//

import Foundation
import Alamofire

class GroqAPIClient {
    
    private let apiKey: String?
    private let baseURL: String
    
    // Initializer
    init() {
        // Set the API key (replace with environment variable in production)
        self.apiKey = "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"
        self.baseURL = "https://api.groq.com/v1"
    }
    
    // Function to send prompt to LLaMA 3 model
    func sendPrompt(_ prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        // Ensure the API key exists
        guard let apiKey = apiKey else {
            print("GROQ_API_KEY is not set")
            completion(.failure(NSError(domain: "API Key Error", code: 401, userInfo: [NSLocalizedDescriptionKey: "API Key is missing"])))
            return
        }
        
        // Update the endpoint URL based on the correct API path
        let endpoint = "\(baseURL)/chat/completions"
        
        // Parameters to be sent in the request
        let parameters: [String: Any] = [
            "prompt": prompt,
            "max_tokens": 500,
            "temperature": 0.7
        ]
        
        // Headers for the request
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]
        
        // Make the request using Alamofire
        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)  // Ensure the response is successful
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any], let result = json["completion"] as? String {
                        // Success, pass the completion text back
                        completion(.success(result))
                    } else {
                        // Parsing error
                        let parsingError = NSError(domain: "ParsingError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to parse completion text"])
                        completion(.failure(parsingError))
                    }
                case .failure(let error):
                    // Handle request error
                    completion(.failure(error))
                }
            }
    }
}
