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
            if let error = service.updateMovie(movie, byID: movie.id, isFavorite: movieRealm.favorite ?? false) {
                self.errorDelegate?.showAlertMessage(title: Constants.General.errorTitle, message: error.rawValue)
            }
            break
        case .failure:
            if let error = service.addMovie(movie) {
                self.errorDelegate?.showAlertMessage(title: Constants.General.errorTitle, message: error.rawValue)
            }
        }
    }
}
