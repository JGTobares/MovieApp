//
//  MovieManager.swift
//  MovieApp
//
//  Created by Julio Gabriel Tobares on 14/04/2022.
//

import Foundation

class MovieManager {
    
    // MARK: - Constants
    let repository: MovieResponseRepository
    
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
    
    // MARK: - Initializers
    init() {
        self.repository = MovieResponseRepository()
    }
    
    init(apiService: BaseAPIService<MoviesResponse>) {
        self.repository = MovieResponseRepository(apiService: apiService)
    }
    
    // MARK: - Functions
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
}
