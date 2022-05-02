//
//  Protocols.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 13/04/22.
//

import Foundation

protocol RealmServiceProtocol {
    
    // MARK: - RealmService
    func addMovie(_ movie: Movie) -> CustomError?
    func addMovie(_ movie: Movie, withCategory category: MoviesCategory) -> CustomError?
    func addMovies(_ movies: [Movie], ofCategory category: MoviesCategory) -> CustomError?
    func addTVShow(_ tvShow: TVShow) -> CustomError?
    func addTVShows(_ shows: [TVShow], ofCategory category: TVShowsCategory) -> CustomError?
    func addFavorite(_ movie: Movie) -> CustomError?
    func getMovieByID(_ id: Int?) -> Result<MovieRealm, CustomError>
    func getMovieByCategory(_ category: MoviesCategory?) -> Result<[MovieRealm], CustomError>
    func getTVShowByCategory(_ category: TVShowsCategory?) -> Result<[TVShowRealm], CustomError>
    func getTVShowByID(_ id: Int?) -> Result<TVShowRealm, CustomError>
    func getFavoriteMovies() -> Result<[MovieRealm], CustomError>
    func getFavoriteTVShows() -> Result<[TVShowRealm], CustomError>
    func getMovieOffline() -> Result<MovieRealm, CustomError>
    func getTVShowOffline() -> Result<TVShowRealm, CustomError>
    func updateMovie(_ movie: Movie, byID id: Int?, isFavorite favorite: Bool, ofCategory category: MoviesCategory?) -> CustomError?
    func updateMovie(_ movie: MovieRealm, isFavorite favorite: Bool) -> CustomError?
    func updateTVShow(_ tvShow: TVShowRealm, isFavorite favorite: Bool) -> CustomError?
    func deleteMovie(_ movie: Movie) -> CustomError?
    func deleteMovie(withID id: Int?) -> CustomError?
    func deleteMovie(_ movie: Movie, withCategory category: MoviesCategory) -> CustomError?
    func deleteMoviesOfCategory(_ category: MoviesCategory) -> CustomError?
}

protocol MovieManagerDelegate {
    
    // MARK: - MovieManager
    func onNowLoaded()
    func onPopularLoaded()
    func onUpcomingLoaded()
    func onBannerLoaded()
}

protocol TVShowManagerDelegate {
    
    // MARK: - MovieManager
    func onTheAirLoaded()
    func onPopularLoaded()
    func onBannerLoaded()
}

protocol SearchResultsManagerDelegate {
    
    // MARK: - SearchResultsManager
    func onSeeAllLoaded()
}

protocol FavoritesManagerDelegate {
    
    // MARK: - FavoritesManager
    func onLoadFavorites()
    func onUpdateFavorites()
}

protocol MovieDetailsViewControllerDelegate {
    
    // MARK: - MovieDetailsViewController
    func didSetMovie(_ movie: Movie)
    func didSetCast(_ cast: [Cast])
    func didSetRating(_ rating: Double)
}

protocol TVShowDetailsViewControllerDelegate {
    
    // MARK: - TVShowDetailsViewController
    func didSetTVShow(_ tvShow: TVShow)
    func didSetCast(_ cast: [Cast])
}

protocol ErrorAlertDelegate {
    
    // MARK: - ErrorAlert
    func showAlertMessage(title: String, message: String)
}
