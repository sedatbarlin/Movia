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
    
    init() {
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
    
    func updateEmail(_ email: String) {
        state.email = email
    }
    func updatePassword(_ password: String) {
        state.password = password
    }
    
    func login() {
        state.isLoading = true
        let user = User(email: state.email, password: state.password)
        print("Login User: \(user)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.state.isLoading = false
        }
    }
}
