//
//  MovieService.swift
//  Movia
//
//  Created by Sedat on 22.05.2025.
//

import Foundation

protocol MovieServiceProtocol {
    func fetchMovies(completion: @escaping (Result<[Movie], NetworkError>) -> Void)
}

class MovieService: MovieServiceProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchMovies(completion: @escaping (Result<[Movie], NetworkError>) -> Void) {
        networkService.request(
            endpoint: "/api/movies",
            method: "GET",
            body: nil,
            completion: completion
        )
    }
} 
