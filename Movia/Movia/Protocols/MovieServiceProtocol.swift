//
//  MovieServiceProtocol.swift
//  Movia
//
//  Created by Sedat on 26.05.2025.
//

import Foundation

protocol MovieServiceProtocol: AnyObject {
    func fetchMovies(completion: @escaping (Result<[Movie], NetworkError>) -> Void)
    func likeMovie(id: Int, completion: @escaping (Result<LikeResponse, NetworkError>) -> Void)
    func unlikeMovie(id: Int, completion: @escaping (Result<LikeResponse, NetworkError>) -> Void)
    func fetchLikedMovies(completion: @escaping (Result<[Int], NetworkError>) -> Void)
}
