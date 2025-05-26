//
//  LoginViewModel.swift
//  Movia
//
//  Created by Sedat on 22.05.2025.
//

import Combine
import Foundation

@MainActor
class LoginViewModel: ObservableObject {
    @Published private(set) var state = LoginState()
    @Published var isFormValid: Bool = false

    private var cancellables = Set<AnyCancellable>()
    private let authService: AuthServiceProtocol
    private let alertManager = AlertManager.shared
    private let keychainManager = KeychainManager.shared

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
            guard let self = self else { return }
            
            Task { @MainActor in
                self.state.isLoading = false
                switch result {
                case .success(let response):
                    if let token = response.token {
                        self.keychainManager.saveToken(token)
                        self.keychainManager.saveUser(response.user)
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    } else {
                        self.alertManager.showLoginError("Token not received")
                    }
                case .failure(let error):
                    if case let .custom(message) = error {
                        self.alertManager.showLoginError(message)
                    } else {
                        self.alertManager.showLoginError(error.localizedDescription)
                    }
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
