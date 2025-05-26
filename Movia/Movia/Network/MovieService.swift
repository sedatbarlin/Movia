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
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            completion(.failure(.custom("Token not found")))
            return
        }
        
        var headers: [HTTPHeader.Key: String] = [:]
        headers[.authorization] = HTTPHeader.Value.bearer(token)
        headers[.contentType] = HTTPHeader.Value.applicationJSON.rawValue
        
        networkService.request(
            endpoint: APIConstants.Endpoints.movies,
            method: .get,
            body: nil,
            headers: headers
        ) { [weak self] result in
            guard self != nil else { return }
            completion(result)
        }
    }
    
    func likeMovie(id: Int, completion: @escaping (Result<LikeResponse, NetworkError>) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            completion(.failure(.custom("Token not found")))
            return
        }
        
        var headers: [HTTPHeader.Key: String] = [:]
        headers[.authorization] = HTTPHeader.Value.bearer(token)
        headers[.contentType] = HTTPHeader.Value.applicationJSON.rawValue
        
        networkService.request(
            endpoint: APIConstants.Endpoints.likeMovie(id: id),
            method: .post,
            body: nil,
            headers: headers
        ) { [weak self] result in
            guard self != nil else { return }
            completion(result)
        }
    }
    
    func unlikeMovie(id: Int, completion: @escaping (Result<LikeResponse, NetworkError>) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            completion(.failure(.custom("Token not found")))
            return
        }
        
        var headers: [HTTPHeader.Key: String] = [:]
        headers[.authorization] = HTTPHeader.Value.bearer(token)
        headers[.contentType] = HTTPHeader.Value.applicationJSON.rawValue
        
        networkService.request(
            endpoint: APIConstants.Endpoints.unlikeMovie(id: id),
            method: .post,
            body: nil,
            headers: headers
        ) { [weak self] result in
            guard self != nil else { return }
            completion(result)
        }
    }
    
    func fetchLikedMovies(completion: @escaping (Result<[Int], NetworkError>) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            completion(.failure(.custom("Token not found")))
            return
        }
        
        var headers: [HTTPHeader.Key: String] = [:]
        headers[.authorization] = HTTPHeader.Value.bearer(token)
        headers[.contentType] = HTTPHeader.Value.applicationJSON.rawValue
        
        networkService.request(
            endpoint: APIConstants.Endpoints.likedMovieIds,
            method: .get,
            body: nil,
            headers: headers
        ) { [weak self] result in
            guard self != nil else { return }
            completion(result)
        }
    }
} 
