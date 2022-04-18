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
    var delegate: MovieManagerDelegate?
    
    // MARK: - Variables
    var nowMovies: [Movie] = []
    var popularMovies: [Movie] = []
    var upcomingMovies: [Movie] = []
    var bannerMovie: Movie!
    
    // MARK: - Initializers
    init() {
        self.apiService = APIService.shared
    }
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    // MARK: - Functions
    func loadNowMovies() {
        apiService.getMoviesNowPlaying() { result in
            switch result {
            case .success(let movies ):
                self.nowMovies = movies
                self.bannerMovie = movies.randomElement()
                self.delegate?.onNowLoaded()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadPopularMovies() {
        apiService.getMoviesPopular() { result in
            switch result {
            case .success(let movies ):
                self.popularMovies = movies
                self.delegate?.onPopularLoaded()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadUpcomingMovies() {
        apiService.getMoviesUpcoming() { result in
            switch result {
            case .success(let movies ):
                self.upcomingMovies = movies
                self.delegate?.onUpcomingLoaded()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    var nowMovieCount: Int {
        return nowMovies.count
    }
    
    func getNowMovie(at: Int) -> Movie{
        return nowMovies[at]
    }
    
    var popularMovieCount: Int {
        return popularMovies.count
    }
    
    func getPopularMovie(at: Int) -> Movie{
        return popularMovies[at]
    }
    
    var upcomingMovieCount: Int {
        return upcomingMovies.count
    }
    
    func getUpcomingMovie(at: Int) -> Movie{
        return upcomingMovies[at]
    }
}
