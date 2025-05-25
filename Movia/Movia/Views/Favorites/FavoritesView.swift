//
//  FavoritesView.swift
//  Movia
//
//  Created by Sedat on 23.05.2025.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        Group {
            if viewModel.state.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .navigationTitle(Strings.favoritesTitle)
            } else if let error = viewModel.state.errorMessage {
                VStack {
                    Text(error)
                        .foregroundColor(.red)
                    Button(Strings.tryAgain) {
                        Task {
                            await viewModel.fetchMovies()
                            await viewModel.fetchLikedMovies()
                        }
                    }
                    .padding(.top)
                }
                .navigationTitle(Strings.favoritesTitle)
            } else {
                let favoriteMovies = viewModel.state.movies.filter { viewModel.isMovieLiked($0) }
                
                if favoriteMovies.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: IconNames.heartSlash)
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text(Strings.noFavorite)
                            .foregroundColor(.gray)
                    }
                    .navigationTitle(Strings.favoritesTitle)
                } else {
                    List(favoriteMovies) { movie in
                        ZStack {
                            MovieRowView(movie: movie)
                                .contentShape(Rectangle())
                            
                            NavigationLink(destination: MovieDetailView(
                                movie: movie,
                                isLiked: true,
                                likeDelegate: viewModel
                            )) {
                                EmptyView()
                            }
                            .opacity(0)
                        }
                        .listRowInsets(EdgeInsets())
                        .listRowSeparatorTint(.gray.opacity(0.3))
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                Task {
                                    await viewModel.unlikeMovie(movie)
                                }
                            } label: {
                                Label(Strings.remove, systemImage: Strings.trash)
                            }
                        }
                    }
                    .listStyle(.plain)
                    .navigationTitle(Strings.favoritesTitle)
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchLikedMovies()
            }
        }
    }
} 
