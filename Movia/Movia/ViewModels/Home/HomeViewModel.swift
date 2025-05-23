//
//  HomeViewModel.swift
//  Movia
//
//  Created by Sedat on 22.05.2025.
//

import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let movieService: MovieServiceProtocol
    
    init(movieService: MovieServiceProtocol = MovieService()) {
        self.movieService = movieService
        Task {
            await fetchMovies()
        }
    }
    
    func fetchMovies() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = await withCheckedContinuation { continuation in
                movieService.fetchMovies { result in
                    continuation.resume(returning: result)
                }
            }
            
            switch result {
            case .success(let movies):
                self.movies = movies
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
} 
