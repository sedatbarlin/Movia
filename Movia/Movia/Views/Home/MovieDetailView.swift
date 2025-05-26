//
//  MovieDetailView.swift
//  Movia
//
//  Created by Sedat on 23.05.2025.
//

import SwiftUI

struct MovieDetailView: View {
    @StateObject private var viewModel: MovieDetailViewModel
    
    init(movie: Movie, isLiked: Bool, likeDelegate: MovieLikeProtocol?) {
        _viewModel = StateObject(wrappedValue: MovieDetailViewModel(
            movie: movie,
            isLiked: isLiked,
            likeDelegate: likeDelegate
        ))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                CachedImage(url: viewModel.state.movie.posterURL, cornerRadius: 12)
                    .frame(width: 200, height: 270)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 16)
                    .shadow(radius: 8)
                
                Text(viewModel.state.movie.title)
                    .font(.title)
                    .bold()
                HStack(spacing: 16) {
                    Text("\(Strings.year): \(String(format: "%d", viewModel.state.movie.year))")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text("\(Strings.category): \(viewModel.state.movie.category)")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                HStack(spacing: 16) {
                    Text("\(Strings.imdb): \(String(format: "%.1f", viewModel.state.movie.rating))")
                        .font(.headline)
                        .foregroundColor(.orange)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(Strings.actors):")
                        .font(.headline)
                    ForEach(viewModel.state.movie.actors, id: \.self) { actor in
                        Text(actor)
                            .font(.subheadline)
                    }
                }
                Text("\(Strings.description):")
                    .font(.headline)
                    .padding(.top, 8)
                Text(viewModel.state.movie.description)
                    .font(.body)
                    .foregroundColor(.primary)
            }
            .padding()
        }
        .navigationTitle(viewModel.state.movie.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task {
                        await viewModel.toggleLike()
                    }
                } label: {
                    Image(systemName: viewModel.state.isLiked ? IconNames.heartFill : IconNames.heart)
                        .foregroundColor(viewModel.state.isLiked ? .red : .gray)
                }
                .disabled(viewModel.state.isLoading)
            }
        }
        .withAlertManager()
    }
}
