//
//  EditProfileViewModel.swift
//  Movia
//
//  Created by Sedat on 23.05.2025.
//

import Foundation

class EditProfileViewModel: ObservableObject {
    @Published private(set) var state: EditProfileState
    
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
        self.state = EditProfileState(
            name: UserDefaults.standard.string(forKey: "userName") ?? "",
            surname: UserDefaults.standard.string(forKey: "userSurname") ?? "",
            email: UserDefaults.standard.string(forKey: "userEmail") ?? ""
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
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                self.state.isLoading = false
                switch result {
                case .success(let response):
                    UserDefaults.standard.set(response.user.name, forKey: "userName")
                    UserDefaults.standard.set(response.user.surname, forKey: "userSurname")
                    UserDefaults.standard.set(response.user.email, forKey: "userEmail")
                    self.state.isSuccess = true
                case .failure(let error):
                    self.state.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
