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
            return "Geçersiz URL"
        case .requestFailed(let error):
            return "İstek başarısız oldu: \(error.localizedDescription)"
        case .invalidResponse:
            return "Geçersiz sunucu yanıtı"
        case .decodingError(let error):
            return "JSON çözme hatası: \(error.localizedDescription)"
        case .serverError(let statusCode):
            return "Sunucu hatası: \(statusCode)"
        case .unknown:
            return "Bilinmeyen bir hata oluştu"
        case .custom(let message):
            return message
        }
    }
}
