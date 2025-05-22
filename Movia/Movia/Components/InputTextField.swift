//
//  InputTextField.swift
//  Movia
//
//  Created by Sedat on 22.05.2025.
//

import SwiftUI

struct InputTextField: View {
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var validationType: ValidationType = .none
    var showValidation: Bool = false

    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                        .textContentType(.password)
                        .focused($isFocused)
                } else {
                    TextField(placeholder, text: $text)
                        .autocapitalization(.none)
                        .keyboardType(validationType == .email ? .emailAddress : .default)
                        .focused($isFocused)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(borderColor, lineWidth: 1)
            )

            if showValidation && isFocused {
                switch validationType {
                case .password:
                    PasswordRulesView(password: text)
                case .email:
                    EmailValidationView(email: text)
                default:
                    EmptyView()
                }
            }
        }
    }

    private var isValid: Bool {
        guard showValidation else { return true }

        switch validationType {
        case .none:
            return true
        case .email:
            return !text.contains(" ") && text.contains("@")
        case .name:
            return text.count >= 3 && text.count <= 20
        case .password:
            return PasswordValidator.validate(password: text).allSatisfy { $0.1 }
        }
    }

    private var borderColor: Color {
        if showValidation && isFocused {
            return isValid ? .green.opacity(0.6) : .red
        } else {
            return .clear
        }
    }
}

enum ValidationType {
    case none, email, password, name
}
