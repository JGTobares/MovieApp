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
    let realmManager: RealmManager
    let reachability = try! Reachability()
    let favoritesManager: FavoritesManager
    let tvShowsManager: TVShowManager
  
    // MARK: - Variables
    var movieBanner: Movie! {
        return self.detailsManager.movie
    }
    var tvShowBanner: TVShow! {
        return self.tvShowsManager.tvShow
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
    var cast: [Cast] {
        return self.detailsManager.cast ?? self.tvShowsManager.cast ?? []
    }
    var castCount: Int {
        return self.cast.count
    }
    var onTheAirTVShowCount: Int {
        return self.tvShowsManager.onTheAirList.count
    }
    var popularTVShowCount: Int {
        return self.tvShowsManager.popularList.count
    }
    
    // MARK: Initializers
    init() {
        self.movieManager = MovieManager()
        self.detailsManager = MovieDetailsManager()
        self.realmManager = RealmManager()
        self.favoritesManager = FavoritesManager()
        self.tvShowsManager = TVShowManager()
    }
    
    init(realmService: RealmServiceProtocol, baseApiServiceMovie: BaseAPIService<Movie>, baseApiServiceMoviesResponse: BaseAPIService<MoviesResponse>, baseApiServiceTVShow: BaseAPIService<TVShow>, baseApiServicesTVShowList: BaseAPIService<TVShowsResponse>) {
        self.movieManager = MovieManager(apiService: baseApiServiceMoviesResponse)
        self.detailsManager = MovieDetailsManager(apiService: baseApiServiceMovie)
        self.realmManager = RealmManager(service: realmService)
        self.favoritesManager = FavoritesManager(service: realmService)
        self.tvShowsManager = TVShowManager(apiService: baseApiServiceTVShow, apiServiceList: baseApiServicesTVShowList)
    }
    
    // MARK: - Functions
    func configureNetwork() {
        do {
            try reachability.startNotifier()
        } catch {
            print(Constants.Network.errorInit)
        }
    }
    
    func getData() {
        reachability.whenReachable = { _ in
            self.getMovies()
        }
        
        reachability.whenUnreachable = { _ in
            self.getMoviesRealm()
            NotificationCenter.default.post(name: Notification.Name(Constants.Network.updateNetworkStatus), object: nil, userInfo: [Constants.Network.updateNetworkStatus : Constants.Network.statusOffline])
        }
        self.configureNetwork()
    }
    
    func getTVShows() {
        reachability.whenReachable = { _ in
            self.getTVShowsAPI()
        }
        
        reachability.whenUnreachable = { _ in
            self.getMoviesRealm()
            NotificationCenter.default.post(name: Notification.Name(Constants.Network.updateNetworkStatus), object: nil, userInfo: [Constants.Network.updateNetworkStatus : Constants.Network.statusOffline])
        }
        self.configureNetwork()
    }
    
    func getData(movieID: Int?) {
        reachability.whenReachable = { _ in
           self.getMovieDetails(id: movieID)
        }
        
        reachability.whenUnreachable = { _ in
            if !self.getMovieDetailsRealm(id: movieID) {
                NotificationCenter.default.post(name: Notification.Name(Constants.Network.updateNetworkStatus), object: nil, userInfo: [Constants.Network.updateNetworkStatus : Constants.Network.statusOffline])
            }
        }
        self.configureNetwork()
    }
    
    func getData(tvShowID: Int?) {
        reachability.whenReachable = { _ in
            self.getTVShow(id: tvShowID)
        }

        reachability.whenUnreachable = { _ in
            if !self.getTVShowRealm(id: tvShowID) {
                NotificationCenter.default.post(name: Notification.Name(Constants.Network.updateNetworkStatus), object: nil, userInfo: [Constants.Network.updateNetworkStatus : Constants.Network.statusOffline])
            }
        }
        self.configureNetwork()
    }
    
    func setMoviesDelegate(_ delegate: MovieManagerDelegate) {
        self.movieManager.delegate = delegate
    }
    
    func setDetailsDelegate(_ delegate: MovieDetailsViewControllerDelegate) {
        self.detailsManager.movieDetailsVCDelegate = delegate
    }
    
    func setDetailsDelegate(_ delegate: TVShowDetailsViewControllerDelegate) {
        self.tvShowsManager.detailsDelegate = delegate
    }
    
    func setFavoritesDelegate(_ delegate: FavoritesManagerDelegate) {
        self.favoritesManager.delegate = delegate
    }
    
    func setTVShowsDelegate(_ delegate: TVShowManagerDelegate) {
        self.tvShowsManager.tvShowsDelegate = delegate
    }
    
    func setErrorDelegate(_ delegate: ErrorAlertDelegate) {
        self.realmManager.errorDelegate = delegate
    }
    
    func getMovies() {
        self.movieManager.loadNowMovies { movies in
            DispatchQueue.main.async {
                self.realmManager.addMovies(movies: movies, category: MoviesCategory.now)
                self.getMovieDetails(id: self.movieManager.bannerMovieID)
            }
        }
        self.movieManager.loadPopularMovies { movies in
            DispatchQueue.main.async {
                self.realmManager.addMovies(movies: movies, category: MoviesCategory.popular)
            }
        }
        self.movieManager.loadUpcomingMovies { movies in
            DispatchQueue.main.async {
                self.realmManager.addMovies(movies: movies, category: MoviesCategory.upcoming)
            }
        }
    }
    
    func getMoviesRealm() {
        guard let nowList = self.realmManager.getMovieList(category: MoviesCategory.now) else {
            return
        }
        self.movieManager.nowMovies = nowList
        self.detailsManager.movie = self.realmManager.getMovieOffline()
        guard let popularList = self.realmManager.getMovieList(category: MoviesCategory.popular) else {
            return
        }
        self.movieManager.popularMovies = popularList
        guard let upcomingList = self.realmManager.getMovieList(category: MoviesCategory.upcoming) else {
            return
        }
        self.movieManager.upcomingMovies = upcomingList
        self.movieManager.delegate?.onNowLoaded()
        self.movieManager.delegate?.onBannerLoaded()
    }
    
    func getTVShowsAPI() {
        self.tvShowsManager.getTVShowList(category: .onTheAir) { onTheAirShows in
            DispatchQueue.main.async {
                //self.realmManager.addMovies(movies: movies, category: MoviesCategory.now)
                self.getTVShow(id: self.tvShowsManager.bannerShowID)
            }
        }
        self.tvShowsManager.getTVShowList(category: .popular) { popularShows in
            DispatchQueue.main.async {
                //self.realmManager.addMovies(movies: movies, category: MoviesCategory.now)
            }
        }
    }
    
    func getTVShowsRealm() {
        guard let onAirList = self.realmManager.getMovieList(category: MoviesCategory.now) else {
            return
        }
        self.tvShowsManager.onTheAirList = onAirList
        self.detailsManager.movie = self.realmManager.getMovieOffline()
        guard let popularList = self.realmManager.getMovieList(category: MoviesCategory.popular) else {
            return
        }
        self.tvShowsManager.popularList = popularList
        self.tvShowsManager.tvShowsDelegate?.onTheAirLoaded()
        self.tvShowsManager.tvShowsDelegate?.onPopularLoaded()
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
    
    func getCast(at index: Int) -> Cast {
        return self.cast[index]
    }
    
    func getOnTheAirTVShow(at index: Int) -> TVShow {
        return self.tvShowsManager.onTheAirList[index]
    }
    
    func getPopularTVShow(at index: Int) -> TVShow {
        return self.tvShowsManager.popularList[index]
    }
    
    func getMovieDetails(id: Int?) {
        self.detailsManager.getMovieDetails(id: id) { movie in
            DispatchQueue.main.async {
                self.realmManager.addMovieDetails(movie: movie)
                self.movieManager.bannerOfflineMovieID = movie.id
                self.detailsManager.getMovieRating(completion: self.saveMovieRating)
            }
            self.movieManager.delegate?.onBannerLoaded()
        }
    }
    
    func saveMovieRating(movie: Movie) {
        DispatchQueue.main.async {
            self.realmManager.addMovieDetails(movie: movie)
        }
        if let rating = movie.rating {
            self.detailsManager.movieDetailsVCDelegate?.didSetRating(rating)
            self.movieManager.delegate?.onBannerLoaded()
        }
    }
    
    func getMovieDetailsRealm(id: Int?) -> Bool {
        guard let movieRealm = self.realmManager.getMovieDetails(id: id) else {
            return false
        }
        self.detailsManager.movie = Movie(movie: movieRealm)
        self.movieManager.delegate?.onBannerLoaded()
        return true
    }
    
    func getTVShow(id: Int?) {
        self.tvShowsManager.getTVShowDetails(id: id) { tvShow in
            DispatchQueue.main.async {
                self.realmManager.addTVShowDetails(tvShow: tvShow)
                self.tvShowsManager.bannerOfflineShowID = tvShow.id
            }
            self.tvShowsManager.tvShowsDelegate?.onBannerLoaded()
        }
    }
    
    func getTVShowRealm(id: Int?) -> Bool {
        guard let tvShowRealm = self.realmManager.getTVShow(id: id) else {
            return false
        }
        self.tvShowsManager.tvShow = TVShow(tvShow: tvShowRealm)
        return true
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
    
    func isTVShowFavorite(tvShowId: Int?) -> Bool {
        return self.favoritesManager.isTVShowFavorite(id: tvShowId)
    }
    
    func updateFavoriteStatus(movieId: Int?, isFavorite favorite: Bool) {
        self.favoritesManager.updateFavoriteStatus(id: movieId, isFavorite: favorite)
    }
    
    func updateFavoriteStatus(tvShowId: Int?, isFavorite favorite: Bool) {
        self.favoritesManager.updateFavoriteStatus(tvShowId: tvShowId, isFavorite: favorite)
    }
}
