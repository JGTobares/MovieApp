//
//  StorageManager.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 20/04/22.
//

import Foundation
import Reachability

class StorageManager {
    
    // MARK: - Constants
    let movieManager: MovieManager
    let detailsManager: MovieDetailsManager
    let realmManager: MovieRealmManager
    let reachability = try! Reachability()
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
        self.configureNetwork()
    }
    
    init(apiService: APIServiceProtocol, realmService: RealmServiceProtocol) {
        self.movieManager = MovieManager(apiService: apiService)
        self.detailsManager = MovieDetailsManager(apiService: apiService)
        self.realmManager = MovieRealmManager(service: realmService)
        self.favoritesManager = FavoritesManager(service: realmService)
    }
    
    // MARK: - Functions
    func configureNetwork() {
        do {
            try reachability.startNotifier()
        } catch {
            print(Constants.Network.errorInit)
        }
    }

    func networkStatus(){
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print( Constants.Network.toastWifiStatus )
            } else {
                print ( Constants.Network.toastCellularStatus )
            }
            NotificationCenter.default.post(name: Notification.Name(Constants.Network.updateNetworkStatus), object: nil, userInfo: [Constants.Network.updateNetworkStatus : Constants.Network.statusOnline])
        }
        
        reachability.whenUnreachable = { _ in
            NotificationCenter.default.post(name: Notification.Name(Constants.Network.updateNetworkStatus), object: nil, userInfo: [Constants.Network.updateNetworkStatus : Constants.Network.statusOffline])
        }
    }
    
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
