//
//  SearchResultsManager.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 18/04/22.
//

import Foundation

class SearchResultsManager {
    
    // MARK: - Constants
    let apiService: APIServiceProtocol
    
    // MARK: - Variables
    var movies: [Movie]? {
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
    func loadNowMovies() {
        apiService.getMoviesNowPlaying() { result in
            switch result {
            case .success(let movies):
                self.movies = movies
            case .failure(let error):
                print(error)
            }
        }
    }
}
