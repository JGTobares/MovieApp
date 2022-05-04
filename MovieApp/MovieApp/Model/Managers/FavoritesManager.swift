//
//  FavoritesManager.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 21/04/22.
//

import Foundation

class FavoritesManager {
    
    // MARK: - Constants
    let realmRepository: RealmRepository
    
    
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
        self.realmRepository = RealmRepository()
    }
    
    init(service: RealmServiceProtocol, baseApiServiceMovie: BaseAPIService<Movie>, baseApiServiceMoviesResponse: BaseAPIService<MoviesResponse>) {
        self.realmRepository = RealmRepository(service: service)
    }
    
    // MARK: - Functions
    func getFavorites() {
        self.realmRepository.getFavoriteMovies { result in
            switch result {
            case .success(let movies):
                self.favoriteMovies = movies.map { movie in
                    Movie(movie: movie)
                }
                self.delegate?.onLoadFavorites()
                break
            case .failure(let error):
                self.errorDelegate?.showAlertMessage(title: Constants.General.errorTitle, message: error.rawValue)
            }
        }
        self.realmRepository.getFavoriteTVShows { result in
            switch result {
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
    }
    
    func isMovieFavorite(id: Int?) -> Bool {
        guard let movie = self.realmRepository.getMovieDetails(id: id) else {
            return false
        }
        return movie.favorite == true
    }
    
    func isTVShowFavorite(id: Int?) -> Bool {
        guard let tvShow = self.realmRepository.getTVShow(id: id) else {
            return false
        }
        return tvShow.favorite == true
    }
    
    func updateFavoriteStatus(id: Int?, isFavorite favorite: Bool) {
        guard let movie = self.realmRepository.getMovieDetails(id: id) else {
            self.errorDelegate?.showAlertMessage(title: Constants.General.errorTitle, message: CustomError.notFoundError.rawValue)
            return
        }
        if let response = self.realmRepository.updateMovie(movie, isFavorite: favorite) {
            self.errorDelegate?.showAlertMessage(title: Constants.General.errorTitle, message: response.rawValue)
        } else {
            if !favorite {
                self.favoriteMovies.removeAll(where: { $0.id == id })
            }
            self.delegate?.onUpdateFavorites()
        }
    }
    
    func updateFavoriteStatus(tvShowId: Int?, isFavorite favorite: Bool) {
        guard let tvShow = self.realmRepository.getTVShow(id: tvShowId) else {
            self.errorDelegate?.showAlertMessage(title: Constants.General.errorTitle, message: CustomError.notFoundError.rawValue)
            return
        }
        if let response = self.realmRepository.updateTVShow(tvShow, isFavorite: favorite) {
            self.errorDelegate?.showAlertMessage(title: Constants.General.errorTitle, message: response.rawValue)
        } else {
            if !favorite {
                self.favoriteTvShows.removeAll(where: { $0.id == tvShowId })
            }
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
}
