//
//  AuthServiceProtocol.swift
//  Movia
//
//  Created by Sedat on 26.05.2025.
//

import Foundation

protocol AuthServiceProtocol {
    func login(request: LoginRequest, completion: @escaping (Result<AuthResponse, NetworkError>) -> Void)
    func register(request: RegisterRequest, completion: @escaping (Result<AuthResponse, NetworkError>) -> Void)
    func updateProfile(request: ProfileUpdateRequest, completion: @escaping (Result<ProfileUpdateResponse, NetworkError>) -> Void)
}
