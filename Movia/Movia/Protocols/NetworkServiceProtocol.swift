//
//  NetworkServiceProtocol.swift
//  Movia
//
//  Created by Sedat on 26.05.2025.
//

import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        body: Data?,
        requiresAuth: Bool,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
    
    func request<T: Decodable, E: Encodable>(
        endpoint: String,
        method: HTTPMethod,
        requestObject: E?,
        requiresAuth: Bool,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
}
