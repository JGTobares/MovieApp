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
}

protocol MovieDetailsViewControllerDelegate {
    
    // MARK: - Functions
    func didSetMovie()
}
