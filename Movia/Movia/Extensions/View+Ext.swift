//
//  View+Ext.swift
//  Movia
//
//  Created by Sedat on 22.05.2025.
//

import SwiftUI

extension View {
    func hideKeyboardOnTap() -> some View {
        self.onTapGesture {
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil, from: nil, for: nil
            )
        }
    }
}

extension View {
    func withAlertManager() -> some View {
        self.modifier(AlertManagerModifier())
    }
}
