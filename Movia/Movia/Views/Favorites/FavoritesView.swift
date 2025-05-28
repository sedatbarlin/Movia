//
//  FavoritesView.swift
//  Movia
//
//  Created by Sedat on 23.05.2025.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var showingDeleteAlert = false
    @State private var selectedMovie: Movie?
    @State private var navigateToDetail = false
    
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
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(favoriteMovies) { movie in
                                FavoriteMovieRow(
                                    movie: movie,
                                    onTap: {
                                        selectedMovie = movie
                                        navigateToDetail = true
                                    },
                                    onDelete: {
                                        selectedMovie = movie
                                        showingDeleteAlert = true
                                    }
                                )
                                
                                if movie.id != favoriteMovies.last?.id {
                                    Divider()
                                        .padding(.leading, 92)
                                }
                            }
                        }
                    }
                    .navigationTitle(Strings.favoritesTitle)
                    .navigationDestination(isPresented: $navigateToDetail) {
                        if let movie = selectedMovie {
                            MovieDetailView(
                                movie: movie,
                                isLiked: true,
                                likeDelegate: viewModel
                            )
                        }
                    }
                    .alert(Strings.removeFromFav, isPresented: $showingDeleteAlert) {
                        Button(Strings.cancel, role: .cancel) {
                            selectedMovie = nil
                        }
                        Button(Strings.remove, role: .destructive) {
                            if let movie = selectedMovie {
                                Task {
                                    await viewModel.unlikeMovie(movie)
                                }
                            }
                            selectedMovie = nil
                        }
                    } message: {
                        if let movie = selectedMovie {
                            Text(Strings.areYouSure + " '" + movie.title + "' " + Strings.fromYourFav)
                        }
                    }
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
