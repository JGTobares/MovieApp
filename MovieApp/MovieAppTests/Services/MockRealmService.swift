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
            movie: Movie(id: 1, backdropPath: "", genres: [], homepage: "", overview: "", rating: 1, posterPath: "", releaseDate: "", runtime: 1, status: "", tagline: "", title: "", credits: nil)),
        MovieRealm(
            movie: Movie(id: 675353, backdropPath: "/egoyMDLqCxzjnSrWOz50uLlJWmD.jpg", genres: [
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
                ], cast: nil)
        ), category: .now)
    ]
    
    let tvShows: [TVShowRealm] = [
        TVShowRealm(),
        TVShowRealm(
            tvShow: TVShow(id: 1, backdropPath: "", genres: [], homepage: "", overview: "", posterPath: "", releaseDate: "", runtime: 1, status: "", tagline: "", title: "", credits: nil)),
        TVShowRealm(
            tvShow: TVShow(id: 675353, backdropPath: "/egoyMDLqCxzjnSrWOz50uLlJWmD.jpg", genres: [
                Genre(id: 28, name: "Action"),
                Genre(id: 878, name: "Science Fiction"),
                Genre(id: 35, name: "Comedy"),
                Genre(id: 10751, name: "Family")
            ],
                homepage: "https://www.sonicthehedgehogmovie.com",
                overview: "... Sonic is eager to prove he has what it takes to be a true hero...",
                posterPath: "/6DrHO1jr3qVrViUO6s6kFiAGM7.jpg",
                releaseDate: "2022-03-30", runtime: 122, status: "Released",
                tagline: "Welcome to the next level.", title: "Sonic the Hedgehog 2",
                credits: Credits(crew: [
                    Crew(id: 3346056, gender: 0, name: "Shuji Utsumi", profilePath: nil, job: "Executive Producer"),
                    Crew(id: 93364, gender: 2, name: "Jeff Fowler", profilePath: "/wExdubFgeBkEUP8MojKPKoOcgdZ.jpg", job: "Director")
                ], cast: nil)
        ))
    ]
    
    init() {
        self.movies[1].favorite = false
        self.movies[2].favorite = true
    }
    
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
    
    func addTVShow(_ tvShow: TVShow) -> CustomError? {
        if tvShow.id == nil {
            return .internalError
        }
        return nil
    }
    
    func addFavorite(_ movie: Movie) -> CustomError? {
        if movie.id == nil {
            return .internalError
        }
        return nil
    }
    
    func getMovieByID(_ id: Int?) -> Result<MovieRealm, CustomError> {
        if id == nil {
            return .failure(.internalError)
        }
        if id == 675353 {
            return .success(self.movies[1])
        }
        return .success(self.movies[2])
    }
    
    func getMovieByCategory(_ category: MoviesCategory?) -> Result<[MovieRealm], CustomError> {
        if category == nil {
            return .failure(.internalError)
        }
        return .success(self.movies)
    }
    
    func getTVShowByID(_ id: Int?) -> Result<TVShowRealm, CustomError> {
        if id == nil {
            return .failure(.internalError)
        }
        if id == 675353 {
            return .success(self.tvShows[2])
        }
        return .success(self.tvShows[1])
    }
    
    func getFavoriteMovies() -> Result<[MovieRealm], CustomError> {
        return .success(self.movies)
    }
    
    func updateMovie(_ movie: Movie, byID id: Int?, isFavorite favorite: Bool, ofCategory category: MoviesCategory?) -> CustomError? {
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
    
    func deleteMovie(withID id: Int?) -> CustomError? {
        if id == nil {
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
    
    func getMovieOffline() -> Result<MovieRealm, CustomError> {
        return .success(self.movies[2])
    }
    
    func getMovieList(category: MoviesCategory?) -> [Movie]? {
        if category == nil {
            return nil
        }
        let moviesList = self.movies.map{
            Movie(movie: $0)
        }
        return moviesList
    }
}
