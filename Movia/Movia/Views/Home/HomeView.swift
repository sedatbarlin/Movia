//
//  HomeView.swift
//  Movia
//
//  Created by Sedat on 22.05.2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .navigationTitle(Strings.movies)
                } else if let error = viewModel.errorMessage {
                    VStack {
                        Text(error)
                            .foregroundColor(.red)
                        Button(Strings.tryAgain) {
                            viewModel.fetchMovies()
                        }
                        .padding(.top)
                    }
                    .navigationTitle(Strings.movies)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(viewModel.movies) { movie in
                                VStack(spacing: 0) {
                                    NavigationLink(destination: MovieDetailView(movie: movie)) {
                                        MovieRowView(movie: movie)
                                            .contentShape(Rectangle())
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    
                                    if movie.id != viewModel.movies.last?.id {
                                        Divider()
                                            .padding(.leading, 92)
                                    }
                                }
                            }
                        }
                    }
                    .navigationTitle(Strings.movies)
                }
            }
            .onAppear {
                viewModel.fetchMovies()
            }
        }
    }
}

struct MovieRowView: View {
    let movie: Movie
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            CachedImage(url: movie.posterURL, cornerRadius: 8)
                .frame(width: 60, height: 90)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline)
                    .lineLimit(2)
                Text("\(Strings.year): \(movie.year)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(movie.category)
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(UIColor.systemBackground))
    }
}
