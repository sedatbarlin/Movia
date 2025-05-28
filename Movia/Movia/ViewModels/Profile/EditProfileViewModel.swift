//
//  EditProfileViewModel.swift
//  Movia
//
//  Created by Sedat on 23.05.2025.
//

import Foundation

@MainActor
class EditProfileViewModel: ObservableObject {
    @Published private(set) var state: EditProfileState
    
    private let authService: AuthServiceProtocol
    private let alertManager = AlertManager.shared
    
    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
        self.state = EditProfileState(
            name: UserDefaults.standard.string(forKey: Strings.UDuserName) ?? "",
            surname: UserDefaults.standard.string(forKey: Strings.UDuserSurname) ?? "",
            email: UserDefaults.standard.string(forKey: Strings.UDuserEmail) ?? ""
        )
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
    
    func updateProfile() {
        state.isLoading = true
        state.errorMessage = nil
        
        let request = ProfileUpdateRequest(
            name: state.name,
            surname: state.surname,
            email: state.email,
            password: state.password.isEmpty ? nil : state.password
        )
        
        authService.updateProfile(request: request) { [weak self] result in
            guard let self = self else { return }
            
            Task { @MainActor in
                self.state.isLoading = false
                switch result {
                case .success(let response):
                    UserDefaults.standard.set(response.user.name, forKey: Strings.UDuserName)
                    UserDefaults.standard.set(response.user.surname, forKey: Strings.UDuserSurname)
                    UserDefaults.standard.set(response.user.email, forKey: Strings.UDuserEmail)
                    self.alertManager.showProfileUpdateSuccess()
                    self.state.isSuccess = true
                case .failure(let error):
                    self.state.errorMessage = error.localizedDescription
                    if case let .custom(message) = error {
                        self.alertManager.showLoginError(message)
                    } else {
                        self.alertManager.showLoginError(error.localizedDescription)
                    }
                }
            }
        }
    }
}
