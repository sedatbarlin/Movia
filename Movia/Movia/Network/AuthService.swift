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
        networkService.request(
            endpoint: APIConstants.Endpoints.login,
            method: .post,
            requestObject: request,
            requiresAuth: false,
            completion: completion
        )
    }

    func register(request: RegisterRequest, completion: @escaping (Result<AuthResponse, NetworkError>) -> Void) {
        networkService.request(
            endpoint: APIConstants.Endpoints.register,
            method: .post,
            requestObject: request,
            requiresAuth: false,
            completion: completion
        )
    }
    
    func updateProfile(request: ProfileUpdateRequest, completion: @escaping (Result<ProfileUpdateResponse, NetworkError>) -> Void) {
        networkService.request(
            endpoint: APIConstants.Endpoints.updateProfile,
            method: .put,
            requestObject: request,
            requiresAuth: true,
            completion: completion
        )
    }
}
