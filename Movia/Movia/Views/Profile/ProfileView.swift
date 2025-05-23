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
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
                .padding(.top, 32)
            
            VStack(spacing: 16) {
                ProfileInfoRow(title: "Name", value: userName)
                ProfileInfoRow(title: "Surname", value: userSurname)
                ProfileInfoRow(title: "Email", value: userEmail)
            }
            .padding(.horizontal)
            
            Button(action: {
                showingEditProfile = true
            }) {
                HStack {
                    Image(systemName: "pencil")
                    Text("Edit Profile")
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
                // Clear user data and logout
                UserDefaults.standard.set(false, forKey: "isLoggedIn")
                UserDefaults.standard.set("", forKey: "userName")
                UserDefaults.standard.set("", forKey: "userSurname")
                UserDefaults.standard.set("", forKey: "userEmail")
                UserDefaults.standard.set("", forKey: "userToken")
            }) {
                Text("Logout")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("Profile")
        .sheet(isPresented: $showingEditProfile) {
            EditProfileView()
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
