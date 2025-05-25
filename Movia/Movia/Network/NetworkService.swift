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
        method: HTTPMethod,
        body: Data?,
        headers: [HTTPHeader.Key: String]?,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
}

class NetworkService: NetworkServiceProtocol {
    private let baseURL: URL?
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.baseURL = URL(string: APIConstants.baseURL)
        self.session = session
    }
    
    struct ErrorResponse: Codable {
        let message: String?
        let error: String?
    }
    
    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        body: Data?,
        headers: [HTTPHeader.Key: String]? = nil,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let baseURL = baseURL,
              let url = URL(string: endpoint, relativeTo: baseURL) else {
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue(HTTPHeader.Value.applicationJSON.rawValue, forHTTPHeaderField: HTTPHeader.Key.contentType.rawValue)
        request.httpBody = body
        
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key.rawValue)
        }

        let task = session.dataTask(with: request) { [weak self] data, response, error in
            guard self != nil else { return }
            
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
                       let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                        if let message = errorResponse.message {
                            completion(.failure(.custom(message)))
                            return
                        } else if let error = errorResponse.error {
                            completion(.failure(.custom(error)))
                            return
                        }
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
        }
        task.resume()
    }
}
