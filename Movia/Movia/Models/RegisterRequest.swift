//
//  RegisterRequest.swift
//  Movia
//
//  Created by Sedat on 22.05.2025.
//

import Foundation

struct RegisterRequest: Codable {
    let name: String
    let surname: String
    let email: String
    let password: String
}
