//
//  ProfileViewModel.swift
//  Movia
//
//  Created by Sedat on 26.05.2025.
//

import Foundation

@MainActor
class ProfileViewModel: ObservableObject {
    @Published private(set) var user: User?
    
    private let keychainManager = KeychainManager.shared
    
    func loadUserData() {
        user = keychainManager.getUser()
    }
    
    func logout() {
        keychainManager.deleteToken()
        keychainManager.deleteUser()
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
    }
} 
