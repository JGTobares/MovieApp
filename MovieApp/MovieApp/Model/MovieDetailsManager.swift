//
//  MovieDetailsRepository.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 14/04/22.
//

import Foundation

class MovieDetailsManager {
    
    // MARK: - Constants
    let apiService: APIServiceProtocol
    let repository: MovieRepository
    
    
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
    var movieDetailsVCDelegate: MovieDetailsViewControllerDelegate?
    var errorDelegate: ErrorAlertDelegate? {
        return self.movieDetailsVCDelegate as? ErrorAlertDelegate
    }
    
    // MARK: - Initializers
    init() {
        self.apiService = APIService.shared
        self.repository = MovieRepository()
    }
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
        self.repository = MovieRepository()
    }
    
    init(apiService: BaseAPIService<Movie>) {
        self.apiService = APIService.shared
        self.repository = MovieRepository(apiService: apiService)
    }
    
    // MARK: - Functions
    func getMovieDetails(id: Int?, completion: @escaping (Movie) -> Void) {
        self.repository.getMovieDetails(id: id) { result in
            switch(result) {
            case .success(let movie):
                self.movie = movie
                completion(movie)
                break
            case .failure(let error):
                self.errorDelegate?.showAlertMessage(title: Constants.General.errorTitle, message: error.rawValue)
            }
        }
    }
}
