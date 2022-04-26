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
        Movie(id: 1, backdropPath: "", genres: [], homepage: "", overview: "", popularity: 1, posterPath: "", releaseDate: "", runtime: 1, status: "", tagline: "", title: "", credits: nil),
        Movie(id: 675353, backdropPath: "/egoyMDLqCxzjnSrWOz50uLlJWmD.jpg", genres: [
                Genre(id: 28, name: "Action"),
                Genre(id: 878, name: "Science Fiction"),
                Genre(id: 35, name: "Comedy"),
                Genre(id: 10751, name: "Family")
              ],
              homepage: "https://www.sonicthehedgehogmovie.com",
              overview: "... Sonic is eager to prove he has what it takes to be a true hero...",
              popularity: 6401.627, posterPath: "/6DrHO1jr3qVrViUO6s6kFiAGM7.jpg",
              releaseDate: "2022-03-30", runtime: 122, status: "Released",
              tagline: "Welcome to the next level.", title: "Sonic the Hedgehog 2",
              credits: Credits(crew: [
                Crew(id: 3346056, gender: 0, name: "Shuji Utsumi", profilePath: nil, job: "Executive Producer"),
                Crew(id: 93364, gender: 2, name: "Jeff Fowler", profilePath: "/wExdubFgeBkEUP8MojKPKoOcgdZ.jpg", job: "Director")
              ], cast: nil))
    ]
    
    func getMovieDetails(id: Int?, completion: @escaping (Result<Movie, CustomError>) -> Void) {
        if id == nil {
            completion(.failure(.internalError))
            return
        }
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
        let moviesResponse = MoviesResponse(page: 1, results: movies, totalPages: 1)
        completion(.success(moviesResponse.results!))
    }
    
    func getMoviesNowPlaying(page: Int? = nil, completion: @escaping (Result<[Movie], CustomError>) -> Void) {
        completion(.success(movies))
    }
    
    func getMoviesUpcoming(page: Int? = nil, completion: @escaping (Result<[Movie], CustomError>) -> Void) {
        completion(.success(movies))
    }
    
    func getMoviesPopular(page: Int? = nil, completion: @escaping (Result<[Movie], CustomError>) -> Void) {
        completion(.success(movies))
    }
    
    func getListOfMovies(page: Int? = nil, endpoint: String, completion: @escaping (Result<[Movie], CustomError>) -> Void) {
        let moviesResponse = MoviesResponse(page: 1, results: movies, totalPages: 1)
        completion(.success(moviesResponse.results!))
    }
    
    func getMoviesResponse(category: MoviesCategory?, completion: @escaping (Result<MoviesResponse, CustomError>) -> Void) {
        let moviesResponse = MoviesResponse(page: 1, results: movies, totalPages: 10)
        completion(.success(moviesResponse))
    }
    
    func searchFor(query: String, page: Int?, completion: @escaping (Result<MoviesResponse, CustomError>) -> Void) {
        if query == "fail" {
            completion(.failure(.internalError))
            return
        }
        let moviesResponse = MoviesResponse(page: 1, results: movies, totalPages: 10)
        completion(.success(moviesResponse))
    }
}
