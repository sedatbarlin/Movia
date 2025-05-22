//
//  AuthResponse.swift
//  Movia
//
//  Created by Sedat on 22.05.2025.
//

import Foundation

struct AuthResponse: Codable {
    let message: String?
    let token: String?
    let user: User
}
