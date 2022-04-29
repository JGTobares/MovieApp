//
//  MovieDetailsRepository.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 14/04/22.
//

import Foundation

class MovieDetailsManager {
    
    // MARK: - Constants
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
        self.repository = MovieRepository()
    }
    
    init(apiService: BaseAPIService<Movie>) {
        self.repository = MovieRepository(apiService: apiService)
    }
    
    // MARK: - Functions
    func getMovieDetails(id: Int?, completion: @escaping (Movie) -> Void) {
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
}
