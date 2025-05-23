//
//  LoginResponse.swift
//  Movia
//
//  Created by Sedat on 23.05.2025.
//

import Foundation

struct LoginResponse: Codable {
    let message: String
    let token: String
    let user: User
} 
