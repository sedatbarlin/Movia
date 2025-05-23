//
//  MoviaApp.swift
//  Movia
//
//  Created by Sedat on 22.05.2025.
//

import SwiftUI

@main
struct MoviaApp: App {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                MainTabView()
            } else {
                LoginView()
            }
        }
    }
}
