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
    }
    
    init(apiService: APIServiceProtocol) {
        self.movieManager = MovieManager(apiService: apiService)
        self.detailsManager = MovieDetailsManager(apiService: apiService)
        self.realmManager = MovieRealmManager()
    }
    
    // MARK: - Functions
    func setMoviesDelegate(_ delegate: MovieManagerDelegate) {
        self.movieManager.delegate = delegate
    }
    
    func setDetailsDelegate(_ delegate: MovieDetailsViewControllerDelegate) {
        self.detailsManager.movieDetailsVCDelegate = delegate
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
}
