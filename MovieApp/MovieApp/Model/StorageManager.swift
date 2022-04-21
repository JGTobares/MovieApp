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
    let favoritesManager: FavoritesManager
    
    // MARK: - Variables
    var movieBanner: Movie! {
        return self.movieManager.bannerMovie
    }
    var nowMovieCount: Int {
        return self.movieManager.nowMovies.count
    }
    var popularMovieCount: Int {
        return self.movieManager.popularMovies.count
    }
    var upcomingMovieCount: Int {
        return self.movieManager.upcomingMovies.count
    }
    
    // MARK: Initializers
    init() {
        self.movieManager = MovieManager()
        self.detailsManager = MovieDetailsManager()
        self.realmManager = MovieRealmManager()
        self.favoritesManager = FavoritesManager()
    }
    
    init(apiService: APIServiceProtocol, realmService: RealmServiceProtocol) {
        self.movieManager = MovieManager(apiService: apiService)
        self.detailsManager = MovieDetailsManager(apiService: apiService)
        self.realmManager = MovieRealmManager(service: realmService)
        self.favoritesManager = FavoritesManager(service: realmService)
    }
    
    // MARK: - Functions
    func setMoviesDelegate(_ delegate: MovieManagerDelegate) {
        self.movieManager.delegate = delegate
    }
    
    func setDetailsDelegate(_ delegate: MovieDetailsViewControllerDelegate) {
        self.detailsManager.movieDetailsVCDelegate = delegate
    }
    
    func setFavoritesDelegate(_ delegate: FavoritesManagerDelegate) {
        self.favoritesManager.delegate = delegate
    }
    
    func getMovies() {
        self.movieManager.loadNowMovies()
        self.movieManager.loadPopularMovies()
        self.movieManager.loadUpcomingMovies()
    }
    
    func getNowMovie(at index: Int) -> Movie {
        return self.movieManager.nowMovies[index]
    }
    
    func getPopularMovie(at index: Int) -> Movie {
        return self.movieManager.popularMovies[index]
    }
    
    func getUpcomingMovie(at index: Int) -> Movie {
        return self.movieManager.upcomingMovies[index]
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
    
    func addFavorite() {
        if let movie = self.detailsManager.movie {
            self.favoritesManager.addFavorite(movie: movie)
        }
    }
    
    func removeFavorite() {
        if let movie = self.detailsManager.movie {
            self.favoritesManager.removeFavorite(movie: movie)
        }
    }
    
    func isMovieFavorite(movieId: Int?) -> Bool {
        return self.favoritesManager.isMovieFavorite(id: movieId)
    }
    
    func updateFavoriteStatus(movieId: Int?, isFavorite favorite: Bool) {
        self.favoritesManager.updateFavoriteStatus(id: movieId, isFavorite: favorite)
    }
}
