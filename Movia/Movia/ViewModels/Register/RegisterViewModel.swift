//
//  RegisterViewModel.swift
//  Movia
//
//  Created by Sedat on 22.05.2025.
//

import Combine
import Foundation

@MainActor
class RegisterViewModel: ObservableObject {
    @Published private(set) var state = RegisterState()
    @Published var isFormValid: Bool = false
    @Published var shouldNavigateToLogin = false

    private var cancellables = Set<AnyCancellable>()
    private let authService: AuthServiceProtocol
    private let alertManager = AlertManager.shared

    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
        bindValidation()
    }

    private func bindValidation() {
        $state
            .map { state in
                let isNameValid = state.name.count >= 3 && state.name.count <= 20
                let isSurnameValid = state.surname.count >= 3 && state.surname.count <= 20
                let isEmailValid = state.email.contains("@") && !state.email.contains(" ")
                let isPasswordValid = PasswordValidator.validate(password: state.password).allSatisfy { $0.1 }
                return isNameValid && isSurnameValid && isEmailValid && isPasswordValid
            }
            .assign(to: \.isFormValid, on: self)
            .store(in: &cancellables)
    }

    func register() {
        state.isLoading = true
        let request = RegisterRequest(
            name: state.name,
            surname: state.surname,
            email: state.email,
            password: state.password
        )
        authService.register(request: request) { [weak self] result in
            guard let self = self else { return }
            
            Task { @MainActor in
                self.state.isLoading = false
                switch result {
                case .success:
                    self.alertManager.showRegistrationSuccess()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.shouldNavigateToLogin = true
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

    func updateName(_ name: String) {
        state.name = name
    }

    func updateSurname(_ surname: String) {
        state.surname = surname
    }

    func updateEmail(_ email: String) {
        state.email = email
    }

    func updatePassword(_ password: String) {
        state.password = password
    }
}
