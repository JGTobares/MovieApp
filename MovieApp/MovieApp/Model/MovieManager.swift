//
//  MovieManager.swift
//  MovieApp
//
//  Created by Julio Gabriel Tobares on 14/04/2022.
//

import Foundation

class MovieManager {
    
    // MARK: - Constants
    let apiService: APIServiceProtocol
    
    // MARK: - Variables
    var nowMovies: [Movie] = []
    var popularMovies: [Movie] = []
    var upcomingMovies: [Movie] = []
    var bannerMovieID: Int?
    var bannerOfflineMovieID: Int?
    var delegate: MovieManagerDelegate?
    
    // MARK: - Initializers
    init() {
        self.apiService = APIService.shared
    }
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    // MARK: - Functions
    func loadNowMovies(completion: @escaping ([Movie]) -> Void) {
        apiService.getMoviesNowPlaying { result in
            switch result {
            case .success(let movies):
                self.nowMovies = movies
                self.bannerMovieID = movies.randomElement()?.id
                completion(movies)
                self.delegate?.onNowLoaded()
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    func loadPopularMovies(completion: @escaping ([Movie]) -> Void) {
        apiService.getMoviesPopular { result in
            switch result {
            case .success(let movies):
                self.popularMovies = movies
                completion(movies)
                self.delegate?.onPopularLoaded()
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    func loadUpcomingMovies(completion: @escaping ([Movie]) -> Void) {
        apiService.getMoviesUpcoming { result in
            switch result {
            case .success(let movies):
                self.upcomingMovies = movies
                completion(movies)
                self.delegate?.onUpcomingLoaded()
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
}
