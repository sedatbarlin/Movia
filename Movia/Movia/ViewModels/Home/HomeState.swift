//
//  HomeState.swift
//  Movia
//
//  Created by Sedat on 23.05.2025.
//

import Foundation

struct HomeState {
    var movies: [Movie] = []
    var likedMovies: Set<Int> = []
    var isLoading: Bool = false
    var errorMessage: String? = nil
} 
