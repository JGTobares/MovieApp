//
//  MockRealmService.swift
//  MovieAppTests
//
//  Created by Fernando Guerrero on 20/04/22.
//

import Foundation

@testable import MovieApp
final class MockRealmService: RealmServiceProtocol {
    
    let movies: [MovieRealm] = [
        MovieRealm(),
        MovieRealm(
            movie: Movie(id: 1, backdropPath: "", genres: [], homepage: "", overview: "", popularity: 1, posterPath: "", releaseDate: "", runtime: 1, status: "", tagline: "", title: "", credits: nil)),
        MovieRealm(
            movie: Movie(id: 675353, backdropPath: "/egoyMDLqCxzjnSrWOz50uLlJWmD.jpg", genres: [
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
                ])
        ), category: .now)
    ]
    
    func addMovie(_ movie: Movie) -> CustomError? {
        if movie.id == nil {
            return .internalError
        }
        return nil
    }
    
    func addMovie(_ movie: Movie, withCategory category: MoviesCategory) -> CustomError? {
        if category == .upcoming {
            return .internalError
        }
        return nil
    }
    
    func addMovies(_ movies: [Movie], ofCategory category: MoviesCategory) -> CustomError? {
        if category == .upcoming {
            return .internalError
        }
        return nil
    }
    
    func getMovieByID(_ id: Int?) -> Result<MovieRealm, CustomError> {
        if id == nil {
            return .failure(.internalError)
        }
        return .success(self.movies[2])
    }
    
    func getMovieByCategory(_ category: MoviesCategory?) -> Result<[MovieRealm], CustomError> {
        if category == nil {
            return .failure(.internalError)
        }
        return .success(self.movies)
    }
    
    func updateMovie(_ movie: Movie, byID id: Int?) -> CustomError? {
        if id == nil {
            return .internalError
        }
        return nil
    }
    
    func updateMovie(_ movie: MovieRealm, isFavorite favorite: Bool) -> CustomError? {
        if movie.category == nil {
            return .internalError
        }
        return nil
    }
    
    func deleteMovie(_ movie: Movie) -> CustomError? {
        if movie.id == nil {
            return .internalError
        }
        return nil
    }
    
    func deleteMovie(_ movie: Movie, withCategory category: MoviesCategory) -> CustomError? {
        if movie.id == nil {
            return .internalError
        }
        return nil
    }
    
    func deleteMoviesOfCategory(_ category: MoviesCategory) -> CustomError? {
        if category == .upcoming {
            return .internalError
        }
        return nil
    }
}
