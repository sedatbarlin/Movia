//
//  LoginView.swift
//  Movia
//
//  Created by Sedat on 22.05.2025.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                InputTextField(
                    placeholder: "Email",
                    text: Binding(
                        get: { viewModel.state.email },
                        set: { viewModel.updateEmail($0) }
                    ),
                    validationType: .email,
                    showValidation: false
                )
                InputTextField(
                    placeholder: "Password",
                    text: Binding(
                        get: { viewModel.state.password },
                        set: { viewModel.updatePassword($0) }
                    ),
                    isSecure: true,
                    validationType: .password,
                    showValidation: false
                )

                MainButton(
                    title: "Giriş Yap",
                    iconName: "arrow.right.circle",
                    isLoading: viewModel.state.isLoading,
                    isDisabled: !viewModel.isFormValid
                ) {
                    viewModel.login()
                }

                Spacer()

                NavigationLink("Hesabın yok mu? Kayıt Ol", destination: RegisterView())
                    .padding(.top, 24)
            }
            .padding()
            .navigationTitle("Giriş Yap")
            .hideKeyboardOnTap()
        }
    }
}
