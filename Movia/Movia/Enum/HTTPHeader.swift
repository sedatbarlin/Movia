//
//  HTTPHeader.swift
//  Movia
//
//  Created by Sedat on 25.05.2025.
//

import Foundation

enum HTTPHeader {
    enum Key: String {
        case contentType = "Content-Type"
        case authorization = "Authorization"
    }
    
    enum Value: String {
        case applicationJSON = "application/json"
        
        static func bearer(_ token: String) -> String {
            return "Bearer \(token)"
        }
    }
}
