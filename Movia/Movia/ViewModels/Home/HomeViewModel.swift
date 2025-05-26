//
//  HomeViewModel.swift
//  Movia
//
//  Created by Sedat on 22.05.2025.
//

import Foundation

@MainActor
class HomeViewModel: ObservableObject{
    @Published private(set) var state = HomeState()
    
    private let movieService: MovieServiceProtocol
    
    init(movieService: MovieServiceProtocol = MovieService()) {
        self.movieService = movieService
        Task {
            await fetchMovies()
            await fetchLikedMovies()
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
    
    func fetchLikedMovies() async {
        let result = await withCheckedContinuation { continuation in
            movieService.fetchLikedMovies { result in
                continuation.resume(returning: result)
            }
        }
        
        switch result {
        case .success(let likedMovieIds):
            state.likedMovies = Set(likedMovieIds)
        case .failure(let error):
            print("Failed to fetch liked movies: \(error.localizedDescription)")
        }
    }
    
    func isMovieLiked(_ movie: Movie) -> Bool {
        state.likedMovies.contains(movie.id)
    }
    
    func unlikeMovie(_ movie: Movie) async -> Bool {
        guard !state.isLoading else { return false }
        
        state.isLoading = true
        defer { state.isLoading = false }
        
        let result = await withCheckedContinuation { continuation in
            movieService.unlikeMovie(id: movie.id) { result in
                continuation.resume(returning: result)
            }
        }
        
        switch result {
        case .success(let response):
            state.likedMovies = Set(response.likedMovies)
            didUnlikeMovie(movie.id)
            return true
        case .failure(let error):
            print("Failed to unlike movie: \(error.localizedDescription)")
            return false
        }
    }
} 

extension HomeViewModel: MovieLikeProtocol {
    func didUpdateLikedMovies(_ likedMovies: Set<Int>) {
        state.likedMovies = likedMovies
    }
    
    func didUnlikeMovie(_ movieId: Int) {
        state.likedMovies.remove(movieId)
    }
}
