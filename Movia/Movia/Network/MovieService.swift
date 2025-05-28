//
//  MovieService.swift
//  Movia
//
//  Created by Sedat on 22.05.2025.
//

import Foundation

class MovieService: MovieServiceProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchMovies(completion: @escaping (Result<[Movie], NetworkError>) -> Void) {
        networkService.request(
            endpoint: APIConstants.Endpoints.movies,
            method: .get,
            requestObject: Optional<String>.none,
            requiresAuth: true,
            completion: completion
        )
    }
    
    func likeMovie(id: Int, completion: @escaping (Result<LikeResponse, NetworkError>) -> Void) {
        networkService.request(
            endpoint: APIConstants.Endpoints.likeMovie(id: id),
            method: .post,
            requestObject: Optional<String>.none,
            requiresAuth: true,
            completion: completion
        )
    }
    
    func unlikeMovie(id: Int, completion: @escaping (Result<LikeResponse, NetworkError>) -> Void) {
        networkService.request(
            endpoint: APIConstants.Endpoints.unlikeMovie(id: id),
            method: .post,
            requestObject: Optional<String>.none,
            requiresAuth: true,
            completion: completion
        )
    }
    
    func fetchLikedMovies(completion: @escaping (Result<[Int], NetworkError>) -> Void) {
        networkService.request(
            endpoint: APIConstants.Endpoints.likedMovieIds,
            method: .get,
            requestObject: Optional<String>.none,
            requiresAuth: true,
            completion: completion
        )
    }
} 
