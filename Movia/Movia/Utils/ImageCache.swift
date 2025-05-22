//
//  ImageCache.swift
//  Movia
//
//  Created by Sedat on 23.05.2025.
//

import SwiftUI

final class ImageCache {
    static let shared = ImageCache()
    private var cache = NSCache<NSString, UIImage>()
    
    private init() {
        cache.countLimit = 100
    }
    
    func add(_ image: UIImage, for url: String) {
        cache.setObject(image, forKey: url as NSString)
    }
    
    func get(_ url: String) -> UIImage? {
        return cache.object(forKey: url as NSString)
    }
    
    func remove(_ url: String) {
        cache.removeObject(forKey: url as NSString)
    }
    
    func clear() {
        cache.removeAllObjects()
    }
} 
