//
//  MovieLikeProtocol.swift
//  Movia
//
//  Created by Sedat on 25.05.2025.
//

import Foundation

@MainActor
protocol MovieLikeProtocol: AnyObject {
    func didUpdateLikedMovies(_ likedMovies: Set<Int>)
    func didUnlikeMovie(_ movieId: Int)
} 
