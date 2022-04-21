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
    
    
    // MARK: - Initializers
    init() {
        service = RealmService()
    }
    
    init(service: RealmServiceProtocol) {
        self.service = service
    }
    
    // MARK: - Functions
    func updateFavoriteStatus(id: Int?, isFavorite favorite: Bool) {
        switch self.service.getMovieByID(id) {
        case .success(let movie):
            if let response = self.service.updateMovie(movie, isFavorite: favorite) {
                print(response.localizedDescription)
            } else {
                // update view
            }
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
