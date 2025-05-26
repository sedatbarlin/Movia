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
        headers: [HTTPHeader.Key: String]?,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
}
