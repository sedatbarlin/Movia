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
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            completion(.failure(.custom("Token not found")))
            return
        }
        
        var headers = ["Authorization": "Bearer \(token)"]
        headers["Content-Type"] = "application/json"
        
        networkService.request(
            endpoint: "/api/movies",
            method: "GET",
            body: nil,
            headers: headers,
            completion: completion
        )
    }
} 
