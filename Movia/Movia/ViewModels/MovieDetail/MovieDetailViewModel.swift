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
    private weak var likeDelegate: MovieLikeProtocol?
    private let alertManager = AlertManager.shared
    
    init(movie: Movie, isLiked: Bool, movieService: MovieServiceProtocol = MovieService(), likeDelegate: MovieLikeProtocol?) {
        self.state = MovieDetailState(movie: movie, isLiked: isLiked)
        self.movieService = movieService
        self.likeDelegate = likeDelegate
    }
    
    func toggleLike() async {
        guard !state.isLoading else { return }
        
        state.isLoading = true
        state.errorMessage = nil
        
        let wasLiked = state.isLiked
        
        let result = await withCheckedContinuation { continuation in
            if wasLiked {
                movieService.unlikeMovie(id: state.movie.id) { result in
                    continuation.resume(returning: result)
                }
            } else {
                movieService.likeMovie(id: state.movie.id) { result in
                    continuation.resume(returning: result)
                }
            }
        }
        
        state.isLoading = false
        
        switch result {
        case .success(let response):
            if !wasLiked {
                alertManager.showMovieLiked(state.movie.title)
            } else {
                alertManager.showMovieUnliked(state.movie.title)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.state.isLiked = response.likedMovies.contains(self.state.movie.id)
                self.likeDelegate?.didUpdateLikedMovies(Set(response.likedMovies))
            }
            
        case .failure(let error):
            state.errorMessage = error.localizedDescription
        }
    }
}
