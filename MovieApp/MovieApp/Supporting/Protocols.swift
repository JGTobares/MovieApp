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
    func searchFor(query: String, page: Int?, completion: @escaping (Result<MoviesResponse, CustomError>) -> Void)
}

protocol RealmServiceProtocol {
    
    // MARK: - Functions
    func addMovie(_ movie: Movie) -> CustomError?
    func addMovie(_ movie: Movie, withCategory category: MoviesCategory) -> CustomError?
    func addMovies(_ movies: [Movie], ofCategory category: MoviesCategory) -> CustomError?
    func addFavorite(_ movie: Movie) -> CustomError?
    func getMovieByID(_ id: Int?) -> Result<MovieRealm, CustomError>
    func getMovieByCategory(_ category: MoviesCategory?) -> Result<[MovieRealm], CustomError>
    func getFavoriteMovies() -> Result<[MovieRealm], CustomError>
    func updateMovie(_ movie: Movie, byID id: Int?, isFavorite favorite: Bool) -> CustomError?
    func updateMovie(_ movie: MovieRealm, isFavorite favorite: Bool) -> CustomError?
    func deleteMovie(_ movie: Movie) -> CustomError?
    func deleteMovie(withID id: Int?) -> CustomError?
    func deleteMovie(_ movie: Movie, withCategory category: MoviesCategory) -> CustomError?
    func deleteMoviesOfCategory(_ category: MoviesCategory) -> CustomError?
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

protocol FavoritesManagerDelegate {
    
    // MARK: - Functions
    func onLoadFavorites()
    func onUpdateFavorites()
}

protocol MovieDetailsViewControllerDelegate {
    
    // MARK: - Functions
    func didSetMovie(_ movie: Movie)
}

protocol ErrorAlertDelegate {
    
    // MARK: - Functions
    func showAlertMessage(title: String, message: String)
}
