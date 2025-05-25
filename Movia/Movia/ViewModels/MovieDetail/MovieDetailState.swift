//
//  MovieDetailState.swift
//  Movia
//
//  Created by Sedat on 25.05.2025.
//

import Foundation

struct MovieDetailState {
    let movie: Movie
    var isLiked: Bool
    var isLoading: Bool = false
    var errorMessage: String? = nil
}
