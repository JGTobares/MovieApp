//
//  StorageManager.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 20/04/22.
//

import Foundation

class StorageManager {
    
    // MARK: - Constants
    let movieManager: MovieManager
    let detailsManager: MovieDetailsManager
    let realmManager: MovieRealmManager
    
    // MARK: Initializers
    init() {
        self.movieManager = MovieManager()
        self.detailsManager = MovieDetailsManager()
        self.realmManager = MovieRealmManager()
    }
    
    init(apiService: APIServiceProtocol) {
        self.movieManager = MovieManager(apiService: apiService)
        self.detailsManager = MovieDetailsManager(apiService: apiService)
        self.realmManager = MovieRealmManager()
    }
    
    // MARK: - Functions
    func setDetailsDelegate(_ delegate: MovieDetailsViewControllerDelegate) {
        self.detailsManager.movieDetailsVCDelegate = delegate
    }
    
    func getMovieDetails(id: Int?) {
        self.detailsManager.getMovieDetails(id: id)
    }
    
    func getMovieDetailsRealm(id: Int?) {
        guard let movieRealm = self.realmManager.getMovieDetails(id: id) else {
            return
        }
        self.detailsManager.movie = Movie(movie: movieRealm)
    }
}
