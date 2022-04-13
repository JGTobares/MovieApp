//
//  MockAPIService.swift
//  MovieAppTests
//
//  Created by Fernando Guerrero on 13/04/22.
//

import Foundation

@testable import MovieApp
final class MockAPIService: APIServiceProtocol {
    
    let movies: [Movie] = [
        Movie(id: 1, genres: [], homepage: "", overview: "", popularity: 1, posterPath: "", releaseDate: "", runtime: 1, status: "", tagline: "", title: ""),
        Movie(id: 675353, genres: [
                Genre(id: 28, name: "Action"),
                Genre(id: 878, name: "Science Fiction"),
                Genre(id: 35, name: "Comedy"),
                Genre(id: 10751, name: "Family")
              ],
              homepage: "https://www.sonicthehedgehogmovie.com",
              overview: "... Sonic is eager to prove he has what it takes to be a true hero...",
              popularity: 6401.627, posterPath: "/6DrHO1jr3qVrViUO6s6kFiAGM7.jpg",
              releaseDate: "2022-03-30", runtime: 122, status: "Released",
              tagline: "Welcome to the next level.", title: "Sonic the Hedgehog 2")
    ]
    
    func getMovieDetails(id: Int?, completion: @escaping (Result<Movie, CustomError>) -> Void) {
        completion(.success(movies[1]))
    }
    
    func getMoviesNowPlaying(completion: @escaping (Result<[Movie], CustomError>) -> Void) {
        completion(.success(movies))
    }
    
    func getMoviesUpcoming(completion: @escaping (Result<[Movie], CustomError>) -> Void) {
        completion(.success(movies))
    }
    
    func getMoviesPopular(completion: @escaping (Result<[Movie], CustomError>) -> Void) {
        completion(.success(movies))
    }
    
    func getListOfMovies(endpoint: String, completion: @escaping (Result<[Movie], CustomError>) -> Void) {
        let moviesResponse = MoviesResponse(results: movies)
        completion(.success(moviesResponse.results!))
    }
}
