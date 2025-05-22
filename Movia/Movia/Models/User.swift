//
//  User.swift
//  Movia
//
//  Created by Sedat on 22.05.2025.
//

import Foundation

struct User: Codable, Identifiable, Equatable {
    var id: String
    var name: String?
    var surname: String?
    var email: String
}
