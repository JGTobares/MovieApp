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
    
    
    // MARK: - Variables
    var errorDelegate: ErrorAlertDelegate?
    
    
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
            self.errorDelegate?.showAlertMessage(title: Constants.General.errorTitle, message: error.rawValue)
        }
        return nil
    }
    
    func addMovieDetails(movie: Movie) {
        switch self.service.getMovieByID(movie.id) {
        case .success(let movieRealm):
            if let error = service.updateMovie(movie, byID: movie.id, isFavorite: movieRealm.favorite ?? false, ofCategory: MoviesCategory(rawValue: movieRealm.category ?? 0)) {
                self.errorDelegate?.showAlertMessage(title: Constants.General.errorTitle, message: error.rawValue)
            }
            break
        case .failure:
            if let error = service.addMovie(movie) {
                self.errorDelegate?.showAlertMessage(title: Constants.General.errorTitle, message: error.rawValue)
            }
        }
    }
    
    func getTVShow(id: Int?) -> TVShowRealm? {
        switch self.service.getTVShowByID(id) {
        case .success(let tvShow):
            return tvShow
        case .failure(let error):
            self.errorDelegate?.showAlertMessage(title: Constants.General.errorTitle, message: error.rawValue)
        }
        return nil
    }
    
    func addTVShowDetails(tvShow: TVShow) {
        if let error = self.service.addTVShow(tvShow) {
            self.errorDelegate?.showAlertMessage(title: Constants.General.errorTitle, message: error.rawValue)
        }
    }
    
    func addMovies(movies: [Movie], category: MoviesCategory) {
        if let error = service.addMovies(movies, ofCategory: category) {
            self.errorDelegate?.showAlertMessage(title: Constants.General.errorTitle, message: error.rawValue)
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
            self.errorDelegate?.showAlertMessage(title: Constants.General.errorTitle, message: error.rawValue)
        }
        return nil
    }
    
    func getMovieOffline() -> Movie? {
        switch self.service.getMovieOffline() {
        case .success(let movie):
            return Movie(movie: movie)
        case .failure(let error):
            self.errorDelegate?.showAlertMessage(title: Constants.General.errorTitle, message: error.rawValue)
        }
        return nil
    }
}
