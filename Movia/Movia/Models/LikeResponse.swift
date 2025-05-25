//
//  LikeResponse.swift
//  Movia
//
//  Created by Sedat on 25.05.2025.
//

import Foundation

struct LikeResponse: Codable {
    let message: String
    let likedMovies: [Int]
} 
