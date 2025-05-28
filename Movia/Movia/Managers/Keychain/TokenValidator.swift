//
//  TokenValidator.swift
//  Movia
//
//  Created by Sedat on 26.05.2025.
//

import Foundation

class TokenValidator {
    static let shared = TokenValidator()
    private init() {}
    
    private let keychainManager = KeychainManager.shared
    
    func validateToken() -> Bool {
        guard let token = keychainManager.getToken() else {
            return false
        }
        
        let components = token.components(separatedBy: ".")
        guard components.count == 3 else {
            return false
        }
        
        guard let payloadData = base64UrlDecode(components[1]),
              let payload = try? JSONSerialization.jsonObject(with: payloadData, options: []) as? [String: Any] else {
            return false
        }
        
        if let exp = payload[Strings.tokenExp] as? TimeInterval {
            let expirationDate = Date(timeIntervalSince1970: exp)
            if Date() >= expirationDate {
                keychainManager.deleteToken()
                return false
            }
            return true
        }
        
        return false
    }
    
    private func base64UrlDecode(_ value: String) -> Data? {
        var base64 = value
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        while base64.count % 4 != 0 {
            base64 += "="
        }
        
        return Data(base64Encoded: base64)
    }
    
    func refreshTokenIfNeeded(completion: @escaping (Bool) -> Void) {
        guard let token = keychainManager.getToken() else {
            completion(false)
            return
        }
        
        let components = token.components(separatedBy: ".")
        guard components.count == 3,
              let payloadData = base64UrlDecode(components[1]),
              let payload = try? JSONSerialization.jsonObject(with: payloadData, options: []) as? [String: Any],
              let exp = payload[Strings.tokenExp] as? TimeInterval else {
            completion(false)
            return
        }
        
        let expirationDate = Date(timeIntervalSince1970: exp)
        let timeUntilExpiration = expirationDate.timeIntervalSince(Date())
        
        if timeUntilExpiration < 1800 { // 30 min
            completion(false)
        } else {
            completion(true)
        }
    }
}
