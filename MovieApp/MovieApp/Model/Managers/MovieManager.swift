//
//  MovieManager.swift
//  MovieApp
//
//  Created by Julio Gabriel Tobares on 14/04/2022.
//

import Foundation
import Reachability

class MovieManager {
    
    // MARK: - Constants
    let repository: MovieResponseRepository
    let detailsManager: MovieDetailsManager
    let reachability = try! Reachability()
    let realmRepository: RealmRepository
    
    
    // MARK: - Variables
    var nowMovies: [Movie] = []
    var popularMovies: [Movie] = []
    var upcomingMovies: [Movie] = []
    var bannerMovieID: Int?
    var bannerOfflineMovieID: Int?
    var delegate: MovieManagerDelegate?
    var errorDelegate: ErrorAlertDelegate? {
        return self.delegate as? ErrorAlertDelegate
    }
    var nowMovieCount: Int {
        return self.nowMovies.count
    }
    var popularMovieCount: Int {
        return self.popularMovies.count
    }
    var upcomingMovieCount: Int {
        return self.upcomingMovies.count
    }
    var movieBanner: Movie! {
        return self.detailsManager.movie
    }
    
    // MARK: - Initializers
    init() {
        self.repository = MovieResponseRepository()
        self.detailsManager = MovieDetailsManager()
        self.realmRepository = RealmRepository()
    }
    
    init(apiService: BaseAPIService<MoviesResponse>, baseApiServiceMovie: BaseAPIService<Movie>, realmService: RealmServiceProtocol, baseApiServiceMoviesResponse: BaseAPIService<MoviesResponse>) {
        self.repository = MovieResponseRepository(apiService: apiService)
        self.detailsManager = MovieDetailsManager(apiService: baseApiServiceMovie, realmService: realmService, baseApiServiceMoviesResponse: baseApiServiceMoviesResponse, baseApiServiceMovie: baseApiServiceMovie)
        self.realmRepository = RealmRepository(service: realmService)
    }
    
    func setMoviesDelegate(_ delegate: MovieManagerDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Functions
    func configureNetwork() {
        do {
            try reachability.startNotifier()
        } catch {
            print(Constants.Network.errorInit)
        }
    }
    
    func getMovieList() {
        reachability.whenReachable = { _ in
            self.getMovies()
        }
        
        reachability.whenUnreachable = { _ in
            self.getMoviesRealm()
            NotificationCenter.default.post(name: Notification.Name(Constants.Network.updateNetworkStatus), object: nil, userInfo: [Constants.Network.updateNetworkStatus : Constants.Network.statusOffline])
        }
        self.configureNetwork()
    }
    
    func getMovies() {
        self.loadNowMovies { movies in
            DispatchQueue.main.async {
                self.realmRepository.addMovies(movies: movies, category: MoviesCategory.now)
                self.detailsManager.getMovieDetails(id: self.bannerMovieID)
            }
        }
        self.loadPopularMovies { movies in
            DispatchQueue.main.async {
                self.realmRepository.addMovies(movies: movies, category: MoviesCategory.popular)
            }
        }
        self.loadUpcomingMovies { movies in
            DispatchQueue.main.async {
                self.realmRepository.addMovies(movies: movies, category: MoviesCategory.upcoming)
            }
        }
    }
    
    func getMoviesRealm() {
        guard let nowList = self.realmRepository.getMovieList(category: MoviesCategory.now) else {
            return
        }
        self.nowMovies = nowList
        self.detailsManager.movie = self.realmRepository.getMovieOffline()
        guard let popularList = self.realmRepository.getMovieList(category: MoviesCategory.popular) else {
            return
        }
        self.popularMovies = popularList
        guard let upcomingList = self.realmRepository.getMovieList(category: MoviesCategory.upcoming) else {
            return
        }
        self.upcomingMovies = upcomingList
        self.delegate?.onNowLoaded()
        self.delegate?.onBannerLoaded()
    }
    
    func loadNowMovies(completion: @escaping ([Movie]) -> Void) {
        repository.getListOfMovies(category: .now) { result in
            switch result {
            case .success(let moviesResponse):
                self.nowMovies = moviesResponse.results ?? []
                self.bannerMovieID = self.nowMovies.randomElement()?.id
                completion(self.nowMovies)
                self.delegate?.onNowLoaded()
            case .failure(let error):
                self.errorDelegate?.showAlertMessage(title: Constants.General.errorTitle, message: error.rawValue)
            }
        }
    }
    
    func loadPopularMovies(completion: @escaping ([Movie]) -> Void) {
        repository.getListOfMovies(category: .popular) { result in
            switch result {
            case .success(let moviesResponse):
                self.popularMovies = moviesResponse.results ?? []
                completion(self.popularMovies)
                self.delegate?.onPopularLoaded()
            case .failure(let error):
                self.errorDelegate?.showAlertMessage(title: Constants.General.errorTitle, message: error.rawValue)
            }
        }
    }
    
    func loadUpcomingMovies(completion: @escaping ([Movie]) -> Void) {
        repository.getListOfMovies(category: .upcoming) { result in
            switch result {
            case .success(let moviesResponse):
                self.upcomingMovies = moviesResponse.results ?? []
                completion(self.upcomingMovies)
                self.delegate?.onPopularLoaded()
            case .failure(let error):
                self.errorDelegate?.showAlertMessage(title: Constants.General.errorTitle, message: error.rawValue)
            }
        }
    }
    
    func getNowMovie(at index: Int) -> Movie {
        return self.nowMovies[index]
    }
    
    func getPopularMovie(at index: Int) -> Movie {
        return self.popularMovies[index]
    }
    
    func getUpcomingMovie(at index: Int) -> Movie {
        return self.upcomingMovies[index]
    }
}
