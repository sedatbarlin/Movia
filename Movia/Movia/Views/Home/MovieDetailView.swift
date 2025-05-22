//
//  MovieDetailView.swift
//  Movia
//
//  Created by Sedat on 23.05.2025.
//

import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                CachedImage(url: movie.posterURL, cornerRadius: 12)
                    .frame(width: 200, height: 270)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 16)
                    .shadow(radius: 8)
                
                Text(movie.title)
                    .font(.title)
                    .bold()
                HStack(spacing: 16) {
                    Text("\(Strings.year): \(movie.year)")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text("\(Strings.category): \(movie.category)")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                HStack(spacing: 16) {
                    Text("\(Strings.imdb): \(String(format: "%.1f", movie.rating))")
                        .font(.headline)
                        .foregroundColor(.orange)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(Strings.actors):")
                        .font(.headline)
                    ForEach(movie.actors, id: \.self) { actor in
                        Text(actor)
                            .font(.subheadline)
                    }
                }
                Text("\(Strings.description):")
                    .font(.headline)
                    .padding(.top, 8)
                Text(movie.description)
                    .font(.body)
                    .foregroundColor(.primary)
            }
            .padding()
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
