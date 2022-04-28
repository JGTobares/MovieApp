//
//  MockBaseAPIService.swift
//  MovieAppTests
//
//  Created by Fernando Guerrero on 28/04/22.
//

import Foundation

@testable import MovieApp
final class MockBaseAPIService<ApiModel: Codable>: BaseAPIService<ApiModel> {
    
    let movies: [Movie] = [
        Movie(id: 1, backdropPath: "", genres: [], homepage: "", overview: "", rating: 1, posterPath: "", releaseDate: "", runtime: 1, status: "", tagline: "", title: "", credits: nil),
        Movie(id: 675353, backdropPath: "/egoyMDLqCxzjnSrWOz50uLlJWmD.jpg", genres: [
                Genre(id: 28, name: "Action"),
                Genre(id: 878, name: "Science Fiction"),
                Genre(id: 35, name: "Comedy"),
                Genre(id: 10751, name: "Family")
              ],
              homepage: "https://www.sonicthehedgehogmovie.com",
              overview: "... Sonic is eager to prove he has what it takes to be a true hero...",
              rating: 6401.627, posterPath: "/6DrHO1jr3qVrViUO6s6kFiAGM7.jpg",
              releaseDate: "2022-03-30", runtime: 122, status: "Released",
              tagline: "Welcome to the next level.", title: "Sonic the Hedgehog 2",
              credits: Credits(crew: [
                Crew(id: 3346056, gender: 0, name: "Shuji Utsumi", profilePath: nil, job: "Executive Producer"),
                Crew(id: 93364, gender: 2, name: "Jeff Fowler", profilePath: "/wExdubFgeBkEUP8MojKPKoOcgdZ.jpg", job: "Director")
              ],
                               cast: [
                Cast(id: 222121, name: "Ben Schwartz", profilePath: "/5vV52TSEIhe4ZZLWwv3i7nfv8we.jpg", character: "Sonic the Hedgehog (voice)")
              ]))
    ]
    
    init() {
        super.init(baseUrl: "")
    }
    
    override func get(endpoint: String, queryParams: [String : String], completion: @escaping (Result<ApiModel, CustomError>) -> Void) {
        let moviesResponse = MoviesResponse(page: 1, results: movies, totalPages: 10)
        if endpoint == "movie/675353" {
            completion(.success(movies[1] as! ApiModel))
        } else if endpoint == "movie/now_playing" {
            completion(.success(moviesResponse as! ApiModel))
        } else if endpoint == "movie/popular" {
            completion(.success(moviesResponse as! ApiModel))
        } else if endpoint == "movie/upcoming" {
            completion(.success(moviesResponse as! ApiModel))
        } else if endpoint == "search/movie" {
            completion(.success(moviesResponse as! ApiModel))
        } else {
            completion(.failure(.internalError))
        }
    }
}
