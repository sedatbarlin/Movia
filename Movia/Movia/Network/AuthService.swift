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

        networkService.request(
            endpoint: "/api/auth/login",
            method: "POST",
            body: body,
            completion: completion
        )
    }

    func register(request: RegisterRequest, completion: @escaping (Result<AuthResponse, NetworkError>) -> Void) {
        guard let body = try? JSONEncoder().encode(request) else {
            completion(.failure(.unknown))
            return
        }

        networkService.request(
            endpoint: "/api/auth/register",
            method: "POST",
            body: body,
            completion: completion
        )
    }
}
