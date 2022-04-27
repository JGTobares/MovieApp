//
//  MovieRealmManager.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 20/04/22.
//

import Foundation

class MovieRealmManager {
    
    // MARK: - Constants
    let service: RealmServiceProtocol
    
    
    // MARK: - Initializers
    init() {
        service = RealmService()
    }
    
    init(service: RealmServiceProtocol) {
        self.service = service
    }
    
    // MARK: - Functions
    func getMovieDetails(id: Int?) -> MovieRealm? {
        switch self.service.getMovieByID(id) {
        case .success(let movie):
            return movie
        case .failure(let error):
            print(error.rawValue)
        }
        return nil
    }
    
    func addMovieDetails(movie: Movie) {
        if let movieRealm = self.getMovieDetails(id: movie.id) {
            if let error = service.updateMovie(movie, byID: movie.id, isFavorite: movieRealm.favorite ?? false, ofCategory: MoviesCategory(rawValue: movieRealm.category ?? 0)) {
                print(error.rawValue)
            }
        } else {
            if let error = service.addMovie(movie) {
                print(error.rawValue)
            }
        }
    }
    
    func addMovies(movies: [Movie], category: MoviesCategory) {
        if let error = service.addMovies(movies, ofCategory: category) {
            print(error.rawValue)
        }
    }
    
    func getMovieList(category: MoviesCategory?) -> [Movie]? {
        switch self.service.getMovieByCategory(_: category) {
        case .success(let moviesRealm):
            let movies = moviesRealm.map { movRealm in
                Movie(movie: movRealm)
            }
            return movies
        case .failure(let error):
            print(error.rawValue)
        }
        return nil
    }
    
    func getMovieOffline() -> Movie? {
        switch self.service.getMovieOffline() {
        case .success(let movie):
            return Movie(movie: movie)
        case .failure(let error):
            print(error.rawValue)
        }
        return nil
    }
}
