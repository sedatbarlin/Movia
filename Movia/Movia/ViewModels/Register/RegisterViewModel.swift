//
//  RegisterViewModel.swift
//  Movia
//
//  Created by Sedat on 22.05.2025.
//

import Combine
import Foundation

class RegisterViewModel: ObservableObject {
    @Published private(set) var state = RegisterState()
    @Published var isFormValid: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
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
    
    func register() {
        state.isLoading = true
        let user = User(name: state.name, surname: state.surname, email: state.email, password: state.password)
        print("Register User: \(user)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.state.isLoading = false
        }
    }
}
