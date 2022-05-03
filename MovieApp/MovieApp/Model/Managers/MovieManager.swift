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
    let responseRepository: MovieResponseRepository
    let repository: MovieRepository
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
    func setErrorDelegate(_ delegate: ErrorAlertDelegate) {
        self.realmRepository.errorDelegate = delegate
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
        return self.movie
    }
    
    var movie: Movie? {
        didSet {
            if let movie = movie {
                self.delegate?.didSetMovie(movie)
                self.cast = movie.credits?.cast
            }
        }
    }
    var cast: [Cast]? {
        didSet {
            if let cast = cast {
                self.delegate?.didSetCast(cast)
            }
        }
    }
    
    var castCount: Int {
        return self.cast?.count ?? 0
    }
    
    
    // MARK: - Initializers
    init() {
        self.responseRepository = MovieResponseRepository()
        self.repository = MovieRepository()
        self.realmRepository = RealmRepository()
    }
    
    init(apiService: BaseAPIService<MoviesResponse>, apiServiceMovie: BaseAPIService<Movie>,  baseApiServiceMovie: BaseAPIService<Movie>, realmService: RealmServiceProtocol, baseApiServiceMoviesResponse: BaseAPIService<MoviesResponse>) {
        self.responseRepository = MovieResponseRepository(apiService: apiService)
        self.repository = MovieRepository(apiService: apiServiceMovie)
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
                self.getMovieDetails(id: self.bannerMovieID)
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
        self.movie = self.realmRepository.getMovieOffline()
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
        responseRepository.getListOfMovies(category: .now) { result in
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
        responseRepository.getListOfMovies(category: .popular) { result in
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
        responseRepository.getListOfMovies(category: .upcoming) { result in
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
    
    //MARK: - MovieDetails Functions
    
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
                self.bannerOfflineMovieID = movie.id
                self.getMovieRating(completion: self.saveMovieRating)
            }
            self.delegate?.onBannerLoaded()
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
        self.delegate?.onBannerLoaded()
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
            self.delegate?.didSetRating(rating)
            self.delegate?.onBannerLoaded()
        }
    }
    
    func getCast(at index: Int) -> Cast {
        return self.cast?[index] ?? Cast(id: 9, name: "", profilePath: "", character: "")
    }
}
