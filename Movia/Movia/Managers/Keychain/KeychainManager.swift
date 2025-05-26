//
//  KeychainManager.swift
//  Movia
//
//  Created by Sedat on 26.05.2025.
//

import Foundation
import Security

class KeychainManager {
    static let shared = KeychainManager()
    private init() {}
    
    private let service = "com.movia.app"
    
    func save(_ data: Data, key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecDuplicateItem {
            try update(data, key: key)
        } else if status != errSecSuccess {
            throw KeychainError.unknown(status)
        }
    }
    
    func update(_ data: Data, key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        
        let attributes: [String: Any] = [
            kSecValueData as String: data
        ]
        
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
    }
    
    func retrieve(key: String) throws -> Data {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
        
        guard let data = result as? Data else {
            throw KeychainError.invalidData
        }
        
        return data
    }
    
    func delete(key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unknown(status)
        }
    }
    
    // MARK: - Token Management
    func saveToken(_ token: String) {
        guard let data = token.data(using: .utf8) else { return }
        try? save(data, key: "userToken")
    }
    
    func getToken() -> String? {
        guard let data = try? retrieve(key: "userToken") else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    func deleteToken() {
        try? delete(key: "userToken")
    }
    
    // MARK: - User Data Management
    func saveUser(_ user: User) {
        guard let data = try? JSONEncoder().encode(user) else { return }
        try? save(data, key: "userData")
    }
    
    func getUser() -> User? {
        guard let data = try? retrieve(key: "userData"),
              let user = try? JSONDecoder().decode(User.self, from: data) else { return nil }
        return user
    }
    
    func deleteUser() {
        try? delete(key: "userData")
    }
}
