//
//  FavoriteMovieRow.swift
//  Movia
//
//  Created by Sedat on 25.05.2025.
//

import SwiftUI

struct FavoriteMovieRow: View {
    let movie: Movie
    let onTap: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onTap) {
                MovieRowView(movie: movie)
            }
            .buttonStyle(PlainButtonStyle())
            
            Button(action: onDelete) {
                Image(systemName: IconNames.trash)
                    .foregroundColor(.red)
                    .padding()
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.trailing, 8)
    }
}
