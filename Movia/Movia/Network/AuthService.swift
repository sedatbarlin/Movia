//
//  AuthService.swift
//  Movia
//
//  Created by Sedat on 22.05.2025.
//

import Foundation

class AuthService: AuthServiceProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func login(request: LoginRequest, completion: @escaping (Result<AuthResponse, NetworkError>) -> Void) {
        guard let body = try? JSONEncoder().encode(request) else {
            completion(.failure(.unknown))
            return
        }

        let headers: [HTTPHeader.Key: String] = [.contentType: HTTPHeader.Value.applicationJSON.rawValue]
        networkService.request(
            endpoint: APIConstants.Endpoints.login,
            method: .post,
            body: body,
            headers: headers
        ) { [weak self] result in
            guard self != nil else { return }
            completion(result)
        }
    }

    func register(request: RegisterRequest, completion: @escaping (Result<AuthResponse, NetworkError>) -> Void) {
        guard let body = try? JSONEncoder().encode(request) else {
            completion(.failure(.unknown))
            return
        }

        let headers: [HTTPHeader.Key: String] = [.contentType: HTTPHeader.Value.applicationJSON.rawValue]
        networkService.request(
            endpoint: APIConstants.Endpoints.register,
            method: .post,
            body: body,
            headers: headers
        ) { [weak self] result in
            guard self != nil else { return }
            completion(result)
        }
    }
    
    func updateProfile(request: ProfileUpdateRequest, completion: @escaping (Result<ProfileUpdateResponse, NetworkError>) -> Void) {
        guard let body = try? JSONEncoder().encode(request) else {
            completion(.failure(.unknown))
            return
        }
        
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            completion(.failure(.custom("Token not found")))
            return
        }
        
        var headers: [HTTPHeader.Key: String] = [:]
        headers[.authorization] = HTTPHeader.Value.bearer(token)
        headers[.contentType] = HTTPHeader.Value.applicationJSON.rawValue
        
        networkService.request(
            endpoint: APIConstants.Endpoints.updateProfile,
            method: .put,
            body: body,
            headers: headers
        ) { [weak self] result in
            guard self != nil else { return }
            completion(result)
        }
    }
}
