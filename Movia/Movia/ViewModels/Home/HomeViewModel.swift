//
//  HomeViewModel.swift
//  Movia
//
//  Created by Sedat on 22.05.2025.
//

import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published private(set) var state = HomeState()
    
    private let movieService: MovieServiceProtocol
    
    init(movieService: MovieServiceProtocol = MovieService()) {
        self.movieService = movieService
        Task {
            await fetchMovies()
        }
    }
    
    func fetchMovies() async {
        state.isLoading = true
        state.errorMessage = nil
        
        let result = await withCheckedContinuation { continuation in
            movieService.fetchMovies { result in
                continuation.resume(returning: result)
            }
        }
        
        switch result {
        case .success(let movies):
            state.movies = movies
        case .failure(let error):
            state.errorMessage = error.localizedDescription
        }
        
        state.isLoading = false
    }
} 
