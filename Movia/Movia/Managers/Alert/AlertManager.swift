//
//  AlertManager.swift
//  Movia
//
//  Created by Sedat on 25.05.2025.
//

import SwiftUI

@MainActor
class AlertManager: ObservableObject {
    @Published var state = AlertState()
    
    static let shared = AlertManager()
    private init() {}
    
    // MARK: - Auth Alerts
    func showLoginError(_ message: String) {
        state.alertItem = AlertState.AlertItem(
            title: Strings.loginFailed,
            message: message,
            type: .error,
            primaryAction: nil
        )
    }
    
    func showRegistrationSuccess() {
        state.alertItem = AlertState.AlertItem(
            title: Strings.success,
            message: Strings.successRegister,
            type: .success,
            primaryAction: nil
        )
    }
    
    // MARK: - Movie Alerts
    func showMovieLiked(_ title: String) {
        state.alertItem = AlertState.AlertItem(
            title: Strings.movieLiked,
            message: "\(title) \(Strings.movieLikedDesc)",
            type: .success,
            primaryAction: nil
        )
    }
    
    func showMovieUnliked(_ title: String) {
        state.alertItem = AlertState.AlertItem(
            title: Strings.movieUnliked,
            message: "\(title) \(Strings.movieUnlikedDesc)",
            type: .warning,
            primaryAction: nil
        )
    }
    
    // MARK: - Profile Alerts
    func showProfileUpdateSuccess() {
        state.alertItem = AlertState.AlertItem(
            title: Strings.profileUpdated,
            message: Strings.profileUpdatedDesc,
            type: .success,
            primaryAction: nil
        )
    }
    
    func showLogoutAlert(onConfirm: @escaping () -> Void) {
        state.alertItem = AlertState.AlertItem(
            title: Strings.logout,
            message: Strings.logoutDesc,
            type: .confirmation,
            primaryAction: onConfirm
        )
    }
    
    func dismissAlert() {
        state.alertItem = nil
    }
    
    func dismissConfirmationDialog() {
        state.confirmationDialog = nil
    }
}
