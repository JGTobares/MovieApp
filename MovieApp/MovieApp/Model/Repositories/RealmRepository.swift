//
//  MovieRealmManager.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 20/04/22.
//

import Foundation

class RealmRepository {
    
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
    
    func addTVShows(shows: [TVShow], category: TVShowsCategory) {
        if let error = service.addTVShows(shows, ofCategory: category) {
            self.errorDelegate?.showAlertMessage(title: Constants.General.errorTitle, message: error.rawValue)
        }
    }
     
    func getTVShowList(category: TVShowsCategory?) -> [TVShow]? {
        switch self.service.getTVShowByCategory(_: category) {
        case .success(let showsRealm):
            let shows = showsRealm.map { showRealm in
                TVShow(tvShow: showRealm)
            }
            return shows
        case .failure(let error):
            self.errorDelegate?.showAlertMessage(title: Constants.General.errorTitle, message: error.rawValue)
        }
        return nil
    }
    
    func getTVShowOffline() -> TVShow? {
        switch self.service.getTVShowOffline() {
        case .success(let show):
            return TVShow(tvShow: show)
        case .failure(let error):
            self.errorDelegate?.showAlertMessage(title: Constants.General.errorTitle, message: error.rawValue)
        }
        return nil
    }
    
    func getFavoriteMovies(completion: @escaping (Result<[MovieRealm], CustomError>) -> Void) {
        completion(self.service.getFavoriteMovies())
    }
    
    func getFavoriteTVShows(completion: @escaping (Result<[TVShowRealm], CustomError>) -> Void) {
        completion(self.service.getFavoriteTVShows())
    }
    
    func updateMovie(_ movie: MovieRealm, isFavorite favorite: Bool) -> CustomError? {
        guard let error = self.service.updateMovie(movie, isFavorite: favorite) else {
            return nil
        }
        return error
    }
    
    func updateTVShow(_ tvShow: TVShowRealm, isFavorite favorite: Bool) -> CustomError? {
        guard let error = self.service.updateTVShow(tvShow, isFavorite: favorite) else {
            return nil
        }
        return error
    }
    
    func addFavorite(movie: Movie) {
        if let response = self.service.addFavorite(movie) {
            self.errorDelegate?.showAlertMessage(title: Constants.General.errorTitle, message: response.rawValue)
        }
    }
    
    func removeFavorite(movie: Movie) {
        if let response = self.service.deleteMovie(movie) {
            self.errorDelegate?.showAlertMessage(title: Constants.General.errorTitle, message: response.rawValue)
        }
    }
    
    // Convenience Function for development
    func deleteAll() {
        if let service = self.service as? RealmService {
            if let response = service.deleteAll() {
                self.errorDelegate?.showAlertMessage(title: Constants.General.errorTitle, message: response.rawValue)
            }
        }
    }
}
