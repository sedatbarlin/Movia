//
//  NetworkError.swift
//  Movia
//
//  Created by Sedat on 22.05.2025.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingError(Error)
    case serverError(statusCode: Int)
    case unknown
    case custom(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return Strings.invalidURL
        case .requestFailed(let error):
            return "\(Strings.requestFailed): \(error.localizedDescription)"
        case .invalidResponse:
            return Strings.invalidResponse
        case .decodingError(let error):
            return "\(Strings.decodingError): \(error.localizedDescription)"
        case .serverError(let statusCode):
            return "\(Strings.serverError): \(statusCode)"
        case .unknown:
            return Strings.unknownError
        case .custom(let message):
            return message
        }
    }
}
