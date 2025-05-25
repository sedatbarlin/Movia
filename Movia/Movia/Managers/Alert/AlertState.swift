//
//  AlertState.swift
//  Movia
//
//  Created by Sedat on 25.05.2025.
//

import Foundation

struct AlertState {
    var alertItem: AlertItem?
    var confirmationDialog: ConfirmationDialog?
    
    struct AlertItem: Identifiable {
        let id = UUID()
        let title: String
        let message: String
        let type: AlertType
        let primaryAction: (() -> Void)?
    }
    
    struct ConfirmationDialog {
        let title: String
        let message: String
        let action: () -> Void
    }
}
