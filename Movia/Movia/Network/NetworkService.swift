//
//  NetworkService.swift
//  Movia
//
//  Created by Sedat on 22.05.2025.
//

import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(
        endpoint: String,
        method: String,
        body: Data?,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
}

class NetworkService: NetworkServiceProtocol {
    private let baseURL = URL(string: "https://moviatask.cerasus.app")!
    
    struct ErrorResponse: Codable {
        let message: String?
    }
    
    func request<T: Decodable>(
        endpoint: String,
        method: String,
        body: Data?,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let url = URL(string: endpoint, relativeTo: baseURL) else {
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(.requestFailed(error)))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(.invalidResponse))
                    return
                }

                guard (200...299).contains(httpResponse.statusCode) else {
                    if let data = data,
                       let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data),
                       let message = errorResponse.message {
                        completion(.failure(.custom(message)))
                        return
                    }
                    completion(.failure(.serverError(statusCode: httpResponse.statusCode)))
                    return
                }

                guard let data = data else {
                    completion(.failure(.unknown))
                    return
                }

                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }.resume()
    }
}
