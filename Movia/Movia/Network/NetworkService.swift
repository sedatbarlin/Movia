//
//  NetworkService.swift
//  Movia
//
//  Created by Sedat on 22.05.2025.
//

import Foundation

class NetworkService {
    private let baseURL: URL?
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let keychainManager: KeychainManager
    private let tokenValidator: TokenValidator
    
    init(
        session: URLSession = .shared,
        keychainManager: KeychainManager = .shared,
        tokenValidator: TokenValidator = .shared
    ) {
        self.baseURL = URL(string: APIConstants.baseURL)
        self.session = session
        self.decoder = JSONDecoder()
        self.encoder = JSONEncoder()
        self.keychainManager = keychainManager
        self.tokenValidator = tokenValidator
    }
    
    private func getAuthenticatedHeaders() -> [HTTPHeader.Key: String]? {
        guard tokenValidator.validateToken(),
              let token = keychainManager.getToken() else {
            return nil
        }
        
        var headers: [HTTPHeader.Key: String] = [:]
        headers[.authorization] = HTTPHeader.Value.bearer(token)
        headers[.contentType] = HTTPHeader.Value.applicationJSON.rawValue
        return headers
    }
    
    private func getDefaultHeaders() -> [HTTPHeader.Key: String] {
        [.contentType: HTTPHeader.Value.applicationJSON.rawValue]
    }
    
    private func decodeResponse<T: Decodable>(_ data: Data) -> Result<T, NetworkError> {
        do {
            let decoded = try decoder.decode(T.self, from: data)
            return .success(decoded)
        } catch {
            return .failure(.decodingError(error))
        }
    }
    
    private func handleErrorResponse(_ data: Data?) -> NetworkError {
        guard let data = data,
              let errorResponse = try? decoder.decode(ErrorResponse.self, from: data) else {
            return .unknown
        }
        
        if let message = errorResponse.message {
            return .custom(message)
        } else if let error = errorResponse.error {
            return .custom(error)
        }
        
        return .unknown
    }
    
    private func validateResponse(_ response: URLResponse?) -> NetworkError? {
        guard let httpResponse = response as? HTTPURLResponse else {
            return .invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            return .serverError(statusCode: httpResponse.statusCode)
        }
        
        return nil
    }
    
    private func handleResponse<T: Decodable>(
        data: Data?,
        response: URLResponse?,
        error: Error?,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        if let error = error {
            completion(.failure(.requestFailed(error)))
            return
        }
        
        if let validationError = validateResponse(response) {
            if case .serverError = validationError {
                completion(.failure(handleErrorResponse(data)))
            } else {
                completion(.failure(validationError))
            }
            return
        }
        
        guard let data = data else {
            completion(.failure(.unknown))
            return
        }
        
        completion(decodeResponse(data))
    }
}

extension NetworkService: NetworkServiceProtocol {
    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        body: Data? = nil,
        requiresAuth: Bool = false,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let baseURL = baseURL,
              let url = URL(string: endpoint, relativeTo: baseURL) else {
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        if requiresAuth {
            guard let authHeaders = getAuthenticatedHeaders() else {
                completion(.failure(.custom("Token not found or invalid")))
                return
            }
            authHeaders.forEach { key, value in
                request.setValue(value, forHTTPHeaderField: key.rawValue)
            }
        } else {
            let defaultHeaders = getDefaultHeaders()
            defaultHeaders.forEach { key, value in
                request.setValue(value, forHTTPHeaderField: key.rawValue)
            }
        }

        let task = session.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.handleResponse(
                    data: data,
                    response: response,
                    error: error,
                    completion: completion
                )
            }
        }
        task.resume()
    }
    
    func request<T: Decodable, E: Encodable>(
        endpoint: String,
        method: HTTPMethod,
        requestObject: E?,
        requiresAuth: Bool = false,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        var bodyData: Data? = nil
        if let requestObject = requestObject {
            do {
                bodyData = try encoder.encode(requestObject)
            } catch {
                completion(.failure(.encodingError(error)))
                return
            }
        }
        
        request(
            endpoint: endpoint,
            method: method,
            body: bodyData,
            requiresAuth: requiresAuth,
            completion: completion
        )
    }
}
