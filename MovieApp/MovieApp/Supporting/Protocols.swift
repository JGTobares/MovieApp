//
//  Protocols.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 13/04/22.
//

import Foundation

protocol APIServiceProtocol {
    
    // MARK: - Functions
    func getMovieDetails(id: Int?, completion: @escaping (Result<Movie, CustomError>) -> Void)
    func getMoviesNowPlaying(completion: @escaping (Result<[Movie], CustomError>) -> Void)
    func getMoviesUpcoming(completion: @escaping (Result<[Movie], CustomError>) -> Void)
    func getMoviesPopular(completion: @escaping (Result<[Movie], CustomError>) -> Void)
    func getListOfMovies(endpoint: String, completion: @escaping (Result<[Movie], CustomError>) -> Void)
    func getMoviesNowPlaying(page: Int?, completion: @escaping (Result<[Movie], CustomError>) -> Void)
    func getMoviesUpcoming(page: Int?, completion: @escaping (Result<[Movie], CustomError>) -> Void)
    func getMoviesPopular(page: Int?, completion: @escaping (Result<[Movie], CustomError>) -> Void)
    func getListOfMovies(page: Int?, endpoint: String, completion: @escaping (Result<[Movie], CustomError>) -> Void)
    func getMoviesResponse(category: MoviesCategory?, completion: @escaping (Result<MoviesResponse, CustomError>) -> Void)
}

protocol MovieManagerDelegate {
    
    // MARK: - Functions
    func onNowLoaded()
    func onPopularLoaded()
    func onUpcomingLoaded()
}

protocol SearchResultsManagerDelegate {
    
    // MARK: - Functions
    func onSeeAllLoaded()
}

protocol MovieDetailsViewControllerDelegate {
    
    // MARK: - Functions
    func didSetMovie()
}
