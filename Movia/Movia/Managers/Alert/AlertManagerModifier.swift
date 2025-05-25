//
//  AlertManagerModifier.swift
//  Movia
//
//  Created by Sedat on 25.05.2025.
//

import SwiftUI

struct AlertManagerModifier: ViewModifier {
    @StateObject private var alertManager = AlertManager.shared
    
    func body(content: Content) -> some View {
        content
            .alert(
                alertManager.state.alertItem?.title ?? "",
                isPresented: Binding(
                    get: { alertManager.state.alertItem != nil },
                    set: { isPresented in
                        if !isPresented {
                            DispatchQueue.main.async {
                                alertManager.state.alertItem = nil
                            }
                        }
                    }
                ),
                actions: {
                    if alertManager.state.alertItem?.type == .confirmation {
                        Button(Strings.cancel, role: .cancel) {
                            DispatchQueue.main.async {
                                alertManager.state.alertItem = nil
                            }
                        }
                        Button(Strings.logout, role: .destructive) {
                            if let action = alertManager.state.alertItem?.primaryAction {
                                action()
                            }
                            DispatchQueue.main.async {
                                alertManager.state.alertItem = nil
                            }
                        }
                    } else {
                        Button(Strings.ok, role: .cancel) {
                            DispatchQueue.main.async {
                                if let action = alertManager.state.alertItem?.primaryAction {
                                    action()
                                }
                                alertManager.state.alertItem = nil
                            }
                        }
                    }
                },
                message: {
                    Text(alertManager.state.alertItem?.message ?? "")
                }
            )
            .confirmationDialog(
                alertManager.state.confirmationDialog?.title ?? "",
                isPresented: Binding(
                    get: { alertManager.state.confirmationDialog != nil },
                    set: { isPresented in
                        if !isPresented {
                            DispatchQueue.main.async {
                                alertManager.state.confirmationDialog = nil
                            }
                        }
                    }
                ),
                titleVisibility: .visible,
                actions: {
                    Button(Strings.ok, role: .destructive) {
                        DispatchQueue.main.async {
                            if let action = alertManager.state.confirmationDialog?.action {
                                action()
                            }
                            alertManager.state.confirmationDialog = nil
                        }
                    }
                    Button(Strings.cancel, role: .cancel) {
                        DispatchQueue.main.async {
                            alertManager.state.confirmationDialog = nil
                        }
                    }
                },
                message: {
                    Text(alertManager.state.confirmationDialog?.message ?? "")
                }
            )
    }
}
