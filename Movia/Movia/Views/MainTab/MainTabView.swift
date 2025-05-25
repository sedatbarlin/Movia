//
//  MainTabView.swift
//  Movia
//
//  Created by Sedat on 23.05.2025.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label(Strings.movies, systemImage: IconNames.film)
            }
            
            NavigationStack {
                FavoritesView()
            }
            .tabItem {
                Label(Strings.favoritesTitle, systemImage: IconNames.heartFill)
            }
            
            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Label(Strings.profile, systemImage: IconNames.personFill)
            }
        }
    }
}
