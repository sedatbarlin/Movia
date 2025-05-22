//
//  LoginView.swift
//  Movia
//
//  Created by Sedat on 22.05.2025.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @State private var shouldNavigate = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                InputTextField(
                    placeholder: Strings.email,
                    text: Binding(
                        get: { viewModel.state.email },
                        set: { viewModel.updateEmail($0) }
                    ),
                    validationType: .email,
                    showValidation: false
                )
                InputTextField(
                    placeholder: Strings.password,
                    text: Binding(
                        get: { viewModel.state.password },
                        set: { viewModel.updatePassword($0) }
                    ),
                    isSecure: true,
                    validationType: .password,
                    showValidation: false
                )

                MainButton(
                    title: Strings.login,
                    iconName: IconNames.login,
                    isLoading: viewModel.state.isLoading,
                    isDisabled: !viewModel.isFormValid
                ) {
                    viewModel.login()
                }
                .onChange(of: isLoggedIn) { _, newValue in
                    if newValue {
                        shouldNavigate = true
                    }
                }

                Spacer()

                NavigationLink(destination: RegisterView()) {
                    Text(Strings.toRegister)
                }
                .padding(.top, 24)
            }
            .padding()
            .navigationTitle(Strings.loginTitle)
            .hideKeyboardOnTap()
            .navigationDestination(isPresented: $shouldNavigate) {
                HomeView()
            }
        }
    }
}
