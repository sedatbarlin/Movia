//
//  RegisterView.swift
//  Movia
//
//  Created by Sedat on 22.05.2025.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 16) {
            InputTextField(
                placeholder: Strings.name,
                text: Binding(
                    get: { viewModel.state.name },
                    set: { viewModel.updateName($0) }
                ),
                validationType: .name,
                showValidation: true
            )
            InputTextField(
                placeholder: Strings.surname,
                text: Binding(
                    get: { viewModel.state.surname },
                    set: { viewModel.updateSurname($0) }
                ),
                validationType: .name,
                showValidation: true
            )
            InputTextField(
                placeholder: Strings.email,
                text: Binding(
                    get: { viewModel.state.email },
                    set: { viewModel.updateEmail($0) }
                ),
                validationType: .email,
                showValidation: true
            )
            InputTextField(
                placeholder: Strings.password,
                text: Binding(
                    get: { viewModel.state.password },
                    set: { viewModel.updatePassword($0) }
                ),
                isSecure: true,
                validationType: .password,
                showValidation: true
            )

            MainButton(
                title: Strings.register,
                backgroundColor: .green,
                iconName: IconNames.register,
                isLoading: viewModel.state.isLoading,
                isDisabled: !viewModel.isFormValid
            ) {
                viewModel.register()
            }

            Spacer()
        }
        .padding()
        .navigationTitle(Strings.registerTitle)
        .hideKeyboardOnTap()
        .withAlertManager()
        .onChange(of: viewModel.shouldNavigateToLogin) { _, shouldNavigate in
            if shouldNavigate {
                dismiss()
            }
        }
    }
}
