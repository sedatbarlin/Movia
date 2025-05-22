//
//  RegisterView.swift
//  Movia
//
//  Created by Sedat on 22.05.2025.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()

    var body: some View {
        VStack(spacing: 16) {
            InputTextField(
                placeholder: "Ad",
                text: Binding(
                    get: { viewModel.state.name },
                    set: { viewModel.updateName($0) }
                ),
                validationType: .name,
                showValidation: true
            )
            InputTextField(
                placeholder: "Soyad",
                text: Binding(
                    get: { viewModel.state.surname },
                    set: { viewModel.updateSurname($0) }
                ),
                validationType: .name,
                showValidation: true
            )
            InputTextField(
                placeholder: "Email",
                text: Binding(
                    get: { viewModel.state.email },
                    set: { viewModel.updateEmail($0) }
                ),
                validationType: .email,
                showValidation: true
            )
            InputTextField(
                placeholder: "Şifre",
                text: Binding(
                    get: { viewModel.state.password },
                    set: { viewModel.updatePassword($0) }
                ),
                isSecure: true,
                validationType: .password,
                showValidation: true
            )

            MainButton(
                title: "Kayıt Ol",
                backgroundColor: .green,
                iconName: "person.badge.plus",
                isLoading: viewModel.state.isLoading,
                isDisabled: !viewModel.isFormValid
            ) {
                viewModel.register()
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Kayıt Ol")
        .hideKeyboardOnTap()
    }
}
