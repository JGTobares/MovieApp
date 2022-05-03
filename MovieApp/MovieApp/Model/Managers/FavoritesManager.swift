//
//  FavoritesManager.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 21/04/22.
//

import Foundation

class FavoritesManager {
    
    // MARK: - Constants
    let service: RealmServiceProtocol
    let realmRepository: RealmRepository
    let movieManager: MovieManager
    
    // MARK: - Variables
    var favoriteMovies: [Movie] = []
    var favoriteTvShows: [TVShow] = []
    var sections: Int {
        return !favoriteMovies.isEmpty && !favoriteTvShows.isEmpty ? 2 : favoriteMovies.isEmpty && favoriteTvShows.isEmpty ? 0 : 1
    }
    var noFavorites: Bool {
        return favoriteMovies.isEmpty && favoriteTvShows.isEmpty
    }
    var delegate: FavoritesManagerDelegate?
    var errorDelegate: ErrorAlertDelegate? {
        return self.delegate as? ErrorAlertDelegate
    }
    
    // MARK: - Initializers
    init() {
        service = RealmService()
        self.realmRepository = RealmRepository()
        self.movieManager = MovieManager()
    }
    
    init(service: RealmServiceProtocol, apiService: BaseAPIService<MoviesResponse>, baseApiServiceMovie: BaseAPIService<Movie>, baseApiServiceMoviesResponse: BaseAPIService<MoviesResponse>) {
        self.service = service
        self.realmRepository = RealmRepository(service: service)
        self.movieManager = MovieManager(apiService: baseApiServiceMoviesResponse, apiServiceMovie: baseApiServiceMovie, baseApiServiceMovie: baseApiServiceMovie, realmService: service, baseApiServiceMoviesResponse: baseApiServiceMoviesResponse)
    }
    
    func setFavoritesDelegate(_ delegate: FavoritesManagerDelegate) {
        self.delegate = delegate
    }
    
    
    // MARK: - Functions
    func getFavorites() {
        switch self.service.getFavoriteMovies() {
        case .success(let movies):
            self.favoriteMovies = movies.map { movie in
                Movie(movie: movie)
            }
            self.delegate?.onLoadFavorites()
            break
        case .failure(let error):
            self.errorDelegate?.showAlertMessage(title: Constants.General.errorTitle, message: error.rawValue)
        }
        switch self.service.getFavoriteTVShows() {
        case .success(let tvShows):
            self.favoriteTvShows = tvShows.map { tvShow in
                TVShow(tvShow: tvShow)
            }
            self.delegate?.onLoadFavorites()
            break
        case .failure(let error):
            self.errorDelegate?.showAlertMessage(title: Constants.General.errorTitle, message: error.rawValue)
        }
    }
    
    func isMovieFavorite(id: Int?) -> Bool {
        switch self.service.getMovieByID(id) {
        case .success(let movie):
            return movie.favorite == true
        case .failure:
            return false
        }
    }
    
    func isTVShowFavorite(id: Int?) -> Bool {
        switch self.service.getTVShowByID(id) {
        case .success(let tvShow):
            return tvShow.favorite == true
        case .failure:
            return false
        }
    }
    
    func updateFavoriteStatus(id: Int?, isFavorite favorite: Bool) {
        switch self.service.getMovieByID(id) {
        case .success(let movie):
            if let response = self.service.updateMovie(movie, isFavorite: favorite) {
                self.errorDelegate?.showAlertMessage(title: Constants.General.errorTitle, message: response.rawValue)
            } else {
                if !favorite {
                    self.favoriteMovies.removeAll(where: { $0.id == id })
                }
                self.delegate?.onUpdateFavorites()
            }
            break
        case .failure(let error):
            self.errorDelegate?.showAlertMessage(title: Constants.General.errorTitle, message: error.rawValue)
        }
    }
    
    func updateFavoriteStatus(tvShowId: Int?, isFavorite favorite: Bool) {
        switch self.service.getTVShowByID(tvShowId) {
        case .success(let tvShow):
            if let response = self.service.updateTVShow(tvShow, isFavorite: favorite) {
                self.errorDelegate?.showAlertMessage(title: Constants.General.errorTitle, message: response.rawValue)
            } else {
                if !favorite {
                    self.favoriteTvShows.removeAll(where: { $0.id == tvShowId })
                }
                self.delegate?.onUpdateFavorites()
            }
            break
        case .failure(let error):
            self.errorDelegate?.showAlertMessage(title: Constants.General.errorTitle, message: error.rawValue)
        }
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
    
    func removeFavorite(id: Int?) {
        if let response = self.service.deleteMovie(withID: id) {
            self.errorDelegate?.showAlertMessage(title: Constants.General.errorTitle, message: response.rawValue)
        } else {
            self.favoriteMovies.removeAll(where: { $0.id == id })
            self.delegate?.onUpdateFavorites()
        }
    }
    
    func getRowsOfSection(_ section: Int) -> Int {
        switch section {
        case 0: return favoriteMovies.isEmpty ? favoriteTvShows.count : favoriteMovies.count
        case 1: return favoriteTvShows.count
        default: return 0
        }
    }
    
    func getFavorite(section: Int, row: Int) -> FavoritesType? {
        switch section {
        case 0: return favoriteMovies.isEmpty ? .tvShow(favoriteTvShows[row]) : .movie(favoriteMovies[row])
        case 1: return .tvShow(favoriteTvShows[row])
        default: return nil
        }
    }
    
    func getTitleOfSection(_ section: Int) -> String {
        switch section {
        case 0: return favoriteMovies.isEmpty ? Constants.SideMenu.tvShows : Constants.SideMenu.movies
        case 1: return Constants.SideMenu.tvShows
        default: return ""
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
    
    func addFavorite() {
        if let movie = self.movieManager.movie {
            self.addFavorite(movie: movie)
        }
    }
    
    func removeFavorite() {
        if let movie = self.movieManager.movie {
            self.removeFavorite(movie: movie)
        }
    }
    
    func isMovieFavorite(movieId: Int?) -> Bool {
        return self.isMovieFavorite(id: movieId)
    }
    
    func isTVShowFavorite(tvShowId: Int?) -> Bool {
        return self.isTVShowFavorite(id: tvShowId)
    }
}
