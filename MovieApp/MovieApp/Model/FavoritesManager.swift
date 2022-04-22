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
    
    
    // MARK: - Variables
    var favoriteMovies: [Movie] = []
    var favoriteTvShows: [AnyObject] = []
    var sections: Int {
        return !favoriteMovies.isEmpty && !favoriteTvShows.isEmpty ? 2 : favoriteMovies.isEmpty && favoriteTvShows.isEmpty ? 0 : 1
    }
    var noFavorites: Bool {
        return favoriteMovies.isEmpty && favoriteTvShows.isEmpty
    }
    var delegate: FavoritesManagerDelegate?
    
    // MARK: - Initializers
    init() {
        service = RealmService()
    }
    
    init(service: RealmServiceProtocol) {
        self.service = service
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
            print(error.rawValue)
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
    
    func updateFavoriteStatus(id: Int?, isFavorite favorite: Bool) {
        switch self.service.getMovieByID(id) {
        case .success(let movie):
            if let response = self.service.updateMovie(movie, isFavorite: favorite) {
                print(response.localizedDescription)
            } else {
                if !favorite {
                    self.favoriteMovies.removeAll(where: { $0.id == id })
                }
                self.delegate?.onUpdateFavorites()
            }
            break
        case .failure(let error):
            print(error.rawValue)
        }
    }
    
    func addFavorite(movie: Movie) {
        if let response = self.service.addFavorite(movie) {
            print(response.localizedDescription)
        }
    }
    
    func removeFavorite(movie: Movie) {
        if let response = self.service.deleteMovie(movie) {
            print(response.localizedDescription)
        }
    }
    
    func removeFavorite(id: Int?) {
        if let response = self.service.deleteMovie(withID: id) {
            print(response.localizedDescription)
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
    
    func getFavorite(section: Int, row: Int) -> AnyObject? {
        switch section {
        case 0: return favoriteMovies.isEmpty ? favoriteTvShows[row] : favoriteMovies[row] as AnyObject
        case 1: return favoriteTvShows[row]
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
                print(response.localizedDescription)
            }
        }
    }
}
