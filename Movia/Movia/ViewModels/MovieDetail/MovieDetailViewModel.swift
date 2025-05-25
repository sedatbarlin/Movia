//
//  MovieDetailViewModel.swift
//  Movia
//
//  Created by Sedat on 25.05.2025.
//

import Foundation

@MainActor
class MovieDetailViewModel: ObservableObject {
    @Published private(set) var state: MovieDetailState
    
    private let movieService: MovieServiceProtocol
    private weak var likeDelegate: MovieLikeDelegate?
    
    init(movie: Movie, isLiked: Bool, movieService: MovieServiceProtocol = MovieService(), likeDelegate: MovieLikeDelegate?) {
        self.state = MovieDetailState(movie: movie, isLiked: isLiked)
        self.movieService = movieService
        self.likeDelegate = likeDelegate
    }
    
    func toggleLike() async {
        guard !state.isLoading else { return }
        
        state.isLoading = true
        state.errorMessage = nil
        
        let result = await withCheckedContinuation { continuation in
            if state.isLiked {
                movieService.unlikeMovie(id: state.movie.id) { result in
                    continuation.resume(returning: result)
                }
            } else {
                movieService.likeMovie(id: state.movie.id) { result in
                    continuation.resume(returning: result)
                }
            }
        }
        
        switch result {
        case .success(let response):
            state.isLiked = response.likedMovies.contains(state.movie.id)
            likeDelegate?.didUpdateLikedMovies(Set(response.likedMovies))
        case .failure(let error):
            state.errorMessage = error.localizedDescription
        }
        
        state.isLoading = false
    }
}
