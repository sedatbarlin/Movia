//
//  EditProfileView.swift
//  Movia
//
//  Created by Sedat on 23.05.2025.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = EditProfileViewModel()
    @State private var isPasswordVisible = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField(Strings.name, text: Binding(
                        get: { viewModel.state.name },
                        set: { viewModel.updateName($0) }
                    ))
                    TextField(Strings.surname, text: Binding(
                        get: { viewModel.state.surname },
                        set: { viewModel.updateSurname($0) }
                    ))
                    TextField(Strings.email, text: Binding(
                        get: { viewModel.state.email },
                        set: { viewModel.updateEmail($0) }
                    ))
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                }
                
                Section {
                    HStack {
                        if isPasswordVisible {
                            TextField(Strings.newPassword, text: Binding(
                                get: { viewModel.state.password },
                                set: { viewModel.updatePassword($0) }
                            ))
                        } else {
                            SecureField(Strings.newPassword, text: Binding(
                                get: { viewModel.state.password },
                                set: { viewModel.updatePassword($0) }
                            ))
                        }
                        
                        Button(action: {
                            isPasswordVisible.toggle()
                        }) {
                            Image(systemName: isPasswordVisible ? IconNames.eyeSlash : IconNames.eyeFill)
                                .foregroundColor(.gray)
                        }
                    }
                } header: {
                    Text(Strings.password)
                } footer: {
                    Text(Strings.leaveEmpty)
                }
                
                if let error = viewModel.state.errorMessage {
                    Section {
                        Text(error)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle(Strings.editProfile)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(Strings.cancel) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(Strings.save) {
                        viewModel.updateProfile()
                    }
                    .disabled(viewModel.state.isLoading)
                }
            }
            .onChange(of: viewModel.state.isSuccess) { _, newValue in
                if newValue {
                    dismiss()
                }
            }
        }
    }
}
