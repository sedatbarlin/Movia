//
//  LoginViewModel.swift
//  Movia
//
//  Created by Sedat on 22.05.2025.
//

import Combine
import Foundation

class LoginViewModel: ObservableObject {
    @Published private(set) var state = LoginState()
    @Published var isFormValid: Bool = false

    private var cancellables = Set<AnyCancellable>()
    private let authService: AuthServiceProtocol

    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
        bindValidation()
    }

    private func bindValidation() {
        $state
            .map { state in
                return state.email.contains("@") && !state.email.contains(" ") &&
                       PasswordValidator.validate(password: state.password).allSatisfy { $0.1 }
            }
            .assign(to: \.isFormValid, on: self)
            .store(in: &cancellables)
    }

    func login() {
        state.isLoading = true
        let request = LoginRequest(
            email: state.email,
            password: state.password
        )
        authService.login(request: request) { [weak self] result in
            self?.state.isLoading = false
            switch result {
            case .success(let response):
                print("Login message: \(response.message ?? "")")
                print("Login success: user=\(response.user), token=\(response.token ?? "")")
            case .failure(let error):
                print("Login failed: \(error.localizedDescription)")
                if case let .custom(message) = error {
                    print("Login error message: \(message)")
                }
            }
        }
    }

    func updateEmail(_ email: String) {
        state.email = email
    }

    func updatePassword(_ password: String) {
        state.password = password
    }
}
