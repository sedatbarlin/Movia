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
                    TextField("Name", text: Binding(
                        get: { viewModel.state.name },
                        set: { viewModel.updateName($0) }
                    ))
                    TextField("Surname", text: Binding(
                        get: { viewModel.state.surname },
                        set: { viewModel.updateSurname($0) }
                    ))
                    TextField("Email", text: Binding(
                        get: { viewModel.state.email },
                        set: { viewModel.updateEmail($0) }
                    ))
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                }
                
                Section {
                    HStack {
                        if isPasswordVisible {
                            TextField("New Password", text: Binding(
                                get: { viewModel.state.password },
                                set: { viewModel.updatePassword($0) }
                            ))
                        } else {
                            SecureField("New Password", text: Binding(
                                get: { viewModel.state.password },
                                set: { viewModel.updatePassword($0) }
                            ))
                        }
                        
                        Button(action: {
                            isPasswordVisible.toggle()
                        }) {
                            Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                        }
                    }
                } header: {
                    Text("Password")
                } footer: {
                    Text("Leave empty if you don't want to change")
                }
                
                if let error = viewModel.state.errorMessage {
                    Section {
                        Text(error)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
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
