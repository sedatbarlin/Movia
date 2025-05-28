//
//  ProfileView.swift
//  Movia
//
//  Created by Sedat on 23.05.2025.
//

import SwiftUI

struct ProfileView: View {
    @AppStorage(Strings.UDisLoggedIn) private var isLoggedIn: Bool = false
    @State private var showingEditProfile = false
    @StateObject private var viewModel = ProfileViewModel()
    private let alertManager = AlertManager.shared
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: IconNames.personCircle)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
                .padding(.top, 32)
            
            VStack(spacing: 16) {
                ProfileInfoRow(title: Strings.name, value: viewModel.user?.name ?? "")
                ProfileInfoRow(title: Strings.surname, value: viewModel.user?.surname ?? "")
                ProfileInfoRow(title: Strings.email, value: viewModel.user?.email ?? "")
            }
            .padding(.horizontal)
            
            Button(action: {
                showingEditProfile = true
            }) {
                HStack {
                    Image(systemName: IconNames.pencil)
                    Text(Strings.editProfile)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Spacer()
            
            Button(action: {
                alertManager.showLogoutAlert {
                    viewModel.logout()
                }
            }) {
                Text(Strings.logout)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle(Strings.profile)
        .sheet(isPresented: $showingEditProfile) {
            EditProfileView()
        }
        .withAlertManager()
        .onAppear {
            viewModel.loadUserData()
        }
    }
}

struct ProfileInfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text(value)
                .font(.body)
            
            Divider()
        }
    }
} 
