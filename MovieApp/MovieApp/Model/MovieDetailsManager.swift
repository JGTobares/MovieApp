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
    
    // MARK: - Variables
    var movie: Movie? {
        didSet {
            self.movieDetailsVCDelegate?.didSetMovie()
        }
    }
    var movieDetailsVCDelegate: MovieDetailsViewControllerDelegate?
    
    // MARK: - Initializers
    init() {
        self.apiService = APIService.shared
    }
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    // MARK: - Functions
    func getMovieDetails(id: Int?) {
        self.apiService.getMovieDetails(id: id) { result in
            switch(result) {
            case .success(let movie):
                self.movie = movie
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
