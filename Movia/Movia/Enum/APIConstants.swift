//
//  APIConstants.swift
//  Movia
//
//  Created by Sedat on 25.05.2025.
//

import Foundation

enum APIConstants {
    static let baseURL = "https://moviatask.cerasus.app"
    
    enum Endpoints {
        static let login = "/api/auth/login"
        static let register = "/api/auth/register"
        static let updateProfile = "/api/users/profile"
        static let movies = "/api/movies"
        static let likedMovieIds = "/api/users/liked-movie-ids"
        
        static func likeMovie(id: Int) -> String {
            return "/api/movies/like/\(id)"
        }
        
        static func unlikeMovie(id: Int) -> String {
            return "/api/movies/unlike/\(id)"
        }
    }
} 
