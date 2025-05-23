//
//  ProfileUpdateRequest.swift
//  Movia
//
//  Created by Sedat on 23.05.2025.
//

import Foundation

struct ProfileUpdateRequest: Codable {
    let name: String
    let surname: String
    let email: String
    let password: String?
} 
