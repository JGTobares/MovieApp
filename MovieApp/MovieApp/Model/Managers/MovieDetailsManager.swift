//
//  MovieDetailsRepository.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 14/04/22.
//

import Foundation
import Reachability

class MovieDetailsManager {
    
    // MARK: - Constants
    let movieManager: MovieManager
    let repository: MovieRepository
    let realmRepository: RealmRepository
    let reachability = try! Reachability()
    
    
    // MARK: - Variables
    var movie: Movie? {
        didSet {
            if let movie = movie {
                self.movieDetailsVCDelegate?.didSetMovie(movie)
                self.cast = movie.credits?.cast
            }
        }
    }
    var cast: [Cast]? {
        didSet {
            if let cast = cast {
                self.movieDetailsVCDelegate?.didSetCast(cast)
            }
        }
    }
    
    /*
    var cast: [Cast] {
        return self.detailsManager.cast ?? self.tvShowsManager.cast ?? []
    }
     */
    
    var castCount: Int {
        return self.cast?.count ?? 0
    }
    var movieDetailsVCDelegate: MovieDetailsViewControllerDelegate?
    var errorDelegate: ErrorAlertDelegate? {
        return self.movieDetailsVCDelegate as? ErrorAlertDelegate
    }
    
    // MARK: - Initializers
    init() {
        self.repository = MovieRepository()
        self.movieManager = MovieManager()
        self.realmRepository = RealmRepository()
    }
    
    init(apiService: BaseAPIService<Movie>, realmService: RealmServiceProtocol, baseApiServiceMoviesResponse: BaseAPIService<MoviesResponse>, baseApiServiceMovie: BaseAPIService<Movie>) {
        self.repository = MovieRepository(apiService: apiService)
        self.realmRepository = RealmRepository(service: realmService)
        self.movieManager = MovieManager(apiService: baseApiServiceMoviesResponse, baseApiServiceMovie: apiService, realmService: realmService, baseApiServiceMoviesResponse: baseApiServiceMoviesResponse)
    }
    
    func setDetailsDelegate(_ delegate: MovieDetailsViewControllerDelegate) {
        self.movieDetailsVCDelegate = delegate
    }
    
    func setErrorDelegate(_ delegate: ErrorAlertDelegate) {
        self.realmRepository.errorDelegate = delegate
    }
    
    // MARK: - Functions
    func configureNetwork() {
        do {
            try reachability.startNotifier()
        } catch {
            print(Constants.Network.errorInit)
        }
    }
    
    func getDetails(movieID: Int?) {
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
    
    func getMovieDetails(id: Int?) {
        self.getMovieDetailsAPI(id: id) { movie in
            DispatchQueue.main.async {
                self.realmRepository.addMovieDetails(movie: movie)
                self.movieManager.bannerOfflineMovieID = movie.id
                self.getMovieRating(completion: self.saveMovieRating)
            }
            self.movieManager.delegate?.onBannerLoaded()
        }
    }
    
    func getMovieDetailsAPI(id: Int?, completion: @escaping (Movie) -> Void) {
        self.repository.getMovieDetails(id: id) { result in
            switch result {
            case .success(let movie):
                self.movie = movie
                completion(movie)
                break
            case .failure(let error):
                self.errorDelegate?.showAlertMessage(title: Constants.General.errorTitle, message: error.rawValue)
            }
        }
    }
    
    func getMovieDetailsRealm(id: Int?) -> Bool {
        guard let movieRealm = self.realmRepository.getMovieDetails(id: id) else {
            return false
        }
        self.movie = Movie(movie: movieRealm)
        self.movieManager.delegate?.onBannerLoaded()
        return true
    }
    
    func getMovieRating(completion: @escaping (Movie) -> Void) {
        self.repository.getMovieRating(id: self.movie?.imdbID) { result in
            switch result {
            case .success(let movie):
                guard let response = movie.response, response == "True", let rating = movie.rating else {
                    self.errorDelegate?.showAlertMessage(title: Constants.General.errorTitle, message: CustomError.notFoundError.rawValue)
                    return
                }
                self.movie?.rating = Double(rating)
                completion(self.movie!)
                break
            case .failure(let error):
                self.errorDelegate?.showAlertMessage(title: Constants.General.errorTitle, message: error.rawValue)
            }
        }
    }
    
    func saveMovieRating(movie: Movie) {
        DispatchQueue.main.async {
            self.realmRepository.addMovieDetails(movie: movie)
        }
        if let rating = movie.rating {
            self.movieDetailsVCDelegate?.didSetRating(rating)
            self.movieManager.delegate?.onBannerLoaded()
        }
    }
    
    func getCast(at index: Int) -> Cast {
        return self.cast?[index] ?? Cast(id: 0, name: "", profilePath: "", character: "")
    }
}
