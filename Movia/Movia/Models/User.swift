//
//  User.swift
//  Movia
//
//  Created by Sedat on 22.05.2025.
//

import Foundation

struct User: Codable, Identifiable, Equatable {
    var id: UUID = UUID()
    var name: String?
    var surname: String?
    var email: String
    var password: String
    
    init(name: String, surname: String, email: String, password: String) {
        self.name = name
        self.surname = surname
        self.email = email
        self.password = password
    }
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
