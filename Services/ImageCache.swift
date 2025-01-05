//
//  ImageCache.swift
//  MoodScape
//
//  Created by Olga Batiunia on 05.01.25.
//


class ImageCache {
    
    static let shared = ImageCache()
    private var cache: [String: UIImage] = [:]
    
    private init() {}
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache[key] = image
    }
    
    func getImage(forKey key: String) -> UIImage? {
        return cache[key]
    }
    
    func clearCache() {
        cache.removeAll()
    }
}
