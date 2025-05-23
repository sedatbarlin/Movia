//
//  AuthService.swift
//  Movia
//
//  Created by Sedat on 22.05.2025.
//

import Foundation

protocol AuthServiceProtocol {
    func login(request: LoginRequest, completion: @escaping (Result<AuthResponse, NetworkError>) -> Void)
    func register(request: RegisterRequest, completion: @escaping (Result<AuthResponse, NetworkError>) -> Void)
    func updateProfile(request: ProfileUpdateRequest, completion: @escaping (Result<ProfileUpdateResponse, NetworkError>) -> Void)
}

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

        let headers = ["Content-Type": "application/json"]
        networkService.request(
            endpoint: "/api/auth/login",
            method: "POST",
            body: body,
            headers: headers,
            completion: completion
        )
    }

    func register(request: RegisterRequest, completion: @escaping (Result<AuthResponse, NetworkError>) -> Void) {
        guard let body = try? JSONEncoder().encode(request) else {
            completion(.failure(.unknown))
            return
        }

        let headers = ["Content-Type": "application/json"]
        networkService.request(
            endpoint: "/api/auth/register",
            method: "POST",
            body: body,
            headers: headers,
            completion: completion
        )
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
        
        var headers = ["Authorization": "Bearer \(token)"]
        headers["Content-Type"] = "application/json"
        
        networkService.request(
            endpoint: "/api/users/profile",
            method: "PUT",
            body: body,
            headers: headers,
            completion: completion
        )
    }
}
