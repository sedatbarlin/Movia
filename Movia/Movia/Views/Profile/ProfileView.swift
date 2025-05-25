//
//  ProfileView.swift
//  Movia
//
//  Created by Sedat on 23.05.2025.
//

import SwiftUI

struct ProfileView: View {
    @AppStorage("userName") private var userName: String = ""
    @AppStorage("userSurname") private var userSurname: String = ""
    @AppStorage("userEmail") private var userEmail: String = ""
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @State private var showingEditProfile = false
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
                ProfileInfoRow(title: Strings.name, value: userName)
                ProfileInfoRow(title: Strings.surname, value: userSurname)
                ProfileInfoRow(title: Strings.email, value: userEmail)
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
                    UserDefaults.standard.set(false, forKey: "isLoggedIn")
                    UserDefaults.standard.set("", forKey: "userName")
                    UserDefaults.standard.set("", forKey: "userSurname")
                    UserDefaults.standard.set("", forKey: "userEmail")
                    UserDefaults.standard.set("", forKey: "userToken")
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
