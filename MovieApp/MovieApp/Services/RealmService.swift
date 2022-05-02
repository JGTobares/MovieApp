//
//  RealmService.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 20/04/22.
//

import Foundation
import RealmSwift

class RealmService: RealmServiceProtocol {
    // MARK: - Constants
    let realm = try? Realm(queue: DispatchQueue.main)
    
    
    // MARK: - Create
    func addMovie(_ movie: Movie) -> CustomError? {
        guard let realm = self.realm else {
            return .realmInstantiationError
        }
        let movie = MovieRealm(movie: movie)
        do {
            try realm.write {
                realm.add(movie, update: .modified)
            }
        } catch {
            return .realmAddError
        }
        return nil
    }
    
    func addMovie(_ movie: Movie, withCategory category: MoviesCategory) -> CustomError? {
        guard let realm = self.realm else {
            return .realmInstantiationError
        }
        let movie = MovieRealm(movie: movie, category: category)
        do {
            try realm.write {
                realm.add(movie)
            }
        } catch {
            return .realmAddError
        }
        return nil
    }

    func addMovies(_ movies: [Movie], ofCategory category: MoviesCategory) -> CustomError? {
        guard let realm = self.realm else {
            return .realmInstantiationError
        }
        let favorites: [MovieRealm]
        switch self.getFavoriteMovies() {
        case .success(let moviesRealm):
            favorites = moviesRealm
            break
        case .failure:
            favorites = []
        }
        let movies = movies.map {
            MovieRealm(movie: $0, category: category)
        }
        favorites.forEach { favorite in
            movies.first(where: { $0.id == favorite.id})?.favorite = favorite.favorite
        }
        do {
            try realm.write {
                realm.add(movies, update: .modified)
            }
        } catch {
            return .realmAddError
        }
        return nil
    }
    
    func addTVShow(_ tvShow: TVShow) -> CustomError? {
        guard let realm = self.realm else {
            return .realmInstantiationError
        }
        do {
            try realm.write {
                let tvShowRealm = TVShowRealm(tvShow: tvShow)
                let favorites = try? self.getFavoriteTVShows().get()
                tvShowRealm.favorite = favorites?.first(where: { $0.id == tvShow.id })?.favorite
                realm.add(tvShowRealm, update: .modified)
            }
        } catch {
            return .realmAddError
        }
        return nil
    }
    
    func addTVShows(_ shows: [TVShow], ofCategory category: TVShowsCategory) -> CustomError? {
        guard let realm = self.realm else {
            return .realmInstantiationError
        }
        let favorites: [TVShowRealm]
        switch self.getFavoriteTVShows() {
        case .success(let tvShowRealm):
            favorites = tvShowRealm
            break
        case .failure:
            favorites = []
        }
        let shows = shows.map {
            TVShowRealm(show: $0, category: category)
        }
        favorites.forEach { favorite in
            shows.first(where: { $0.id == favorite.id})?.favorite = favorite.favorite
        }
        do {
            try realm.write {
                realm.add(shows, update: .modified)
            }
        } catch {
            return .realmAddError
        }
        return nil
    }
    
    func addFavorite(_ movie: Movie) -> CustomError? {
        guard let realm = self.realm else {
            return .realmInstantiationError
        }
        let movie = MovieRealm(movie: movie)
        movie.favorite = true
        do {
            try realm.write {
                realm.add(movie)
            }
        } catch {
            return .realmAddError
        }
        return nil
    }
    
    // MARK: - Read
    func getMovieOffline() -> Result<MovieRealm, CustomError> {
        guard let realm = self.realm else {
            return .failure(.realmInstantiationError)
        }
        let movie = realm.objects(MovieRealm.self)
        guard let result = movie.randomElement() else { return .failure(.notFoundError) }
        return .success(result)
    }
    
    func getMovieByID(_ id: Int?) -> Result<MovieRealm, CustomError> {
        guard let realm = self.realm else {
            return .failure(.realmInstantiationError)
        }
        guard let id = id else {
            return .failure(.internalError)
        }
        if let movie = realm.object(ofType: MovieRealm.self, forPrimaryKey: id) {
            return .success(movie)
        }
        return .failure(.notFoundError)
    }
    
    func getMovieByCategory(_ category: MoviesCategory?) -> Result<[MovieRealm], CustomError> {
        guard let realm = self.realm else {
            return .failure(.realmInstantiationError)
        }
        guard let category = category else {
            return .failure(.internalError)
        }
        let movies = realm.objects(MovieRealm.self).where {
            $0.category == category.rawValue
        }
        return .success(Array(movies))
    }
    
    func getTVShowByCategory(_ category: TVShowsCategory?) -> Result<[TVShowRealm], CustomError> {
        guard let realm = self.realm else {
            return .failure(.realmInstantiationError)
        }
        guard let category = category else {
            return .failure(.internalError)
        }
        let shows = realm.objects(TVShowRealm.self).where {
            $0.category == category.rawValue
        }
        return .success(Array(shows))
    }
    
    func getTVShowOffline() -> Result<TVShowRealm, CustomError> {
        guard let realm = self.realm else {
            return .failure(.realmInstantiationError)
        }
        let show = realm.objects(TVShowRealm.self)
        guard let result = show.randomElement() else { return .failure(.notFoundError) }
        return .success(result)
    }
    
    func getTVShowByID(_ id: Int?) -> Result<TVShowRealm, CustomError> {
        guard let realm = self.realm else {
            return .failure(.realmInstantiationError)
        }
        guard let id = id else {
            return .failure(.internalError)
        }
        if let tvShow = realm.object(ofType: TVShowRealm.self, forPrimaryKey: id) {
            return .success(tvShow)
        }
        return .failure(.notFoundError)
    }
    
    func getFavoriteMovies() -> Result<[MovieRealm], CustomError> {
        guard let realm = self.realm else {
            return .failure(.realmInstantiationError)
        }
        let movies = realm.objects(MovieRealm.self).where {
            $0.favorite == true
        }
        return .success(Array(movies))
    }
    
    func getFavoriteTVShows() -> Result<[TVShowRealm], CustomError> {
        guard let realm = self.realm else {
            return .failure(.realmInstantiationError)
        }
        let tvShows = realm.objects(TVShowRealm.self).where {
            $0.favorite == true
        }
        return .success(Array(tvShows))
    }
    
    // MARK: - Update
    func updateMovie(_ movie: Movie, byID id: Int?, isFavorite favorite: Bool, ofCategory category: MoviesCategory?) -> CustomError? {
        guard let realm = self.realm else {
            return .realmInstantiationError
        }
        let movie = MovieRealm(movie: movie)
        movie.favorite = favorite
        movie.category = category?.rawValue
        do {
            try realm.write {
                realm.add(movie, update: .modified)
            }
        } catch {
            return .realmUpdateError
        }
        return nil
    }
    
    func updateMovie(_ movie: MovieRealm, isFavorite favorite: Bool) -> CustomError? {
        guard let realm = self.realm else {
            return .realmInstantiationError
        }
        do {
            try realm.write {
                movie.favorite = favorite
            }
        } catch {
            return .realmUpdateError
        }
        return nil
    }
    
    func updateTVShow(_ tvShow: TVShowRealm, isFavorite favorite: Bool) -> CustomError? {
        guard let realm = self.realm else {
            return .realmInstantiationError
        }
        do {
            try realm.write {
                tvShow.favorite = favorite
            }
        } catch {
            return .realmUpdateError
        }
        return nil
    }
    
    // MARK: - Delete
    func deleteMovie(_ movie: Movie) -> CustomError? {
        guard let realm = self.realm else {
            return .realmInstantiationError
        }
        switch self.getMovieByID(movie.id) {
        case .success(let movieRealm):
            do {
                try realm.write {
                    realm.delete(movieRealm)
                }
            } catch {
                return .realmDeleteError
            }
        case .failure(let error):
            return error
        }
        return nil
    }
    
    func deleteMovie(withID id: Int?) -> CustomError? {
        guard let realm = self.realm else {
            return .realmInstantiationError
        }
        switch self.getMovieByID(id) {
        case .success(let movieRealm):
            do {
                try realm.write {
                    realm.delete(movieRealm)
                }
            } catch {
                return .realmDeleteError
            }
            break
        case .failure(let error):
            return error
        }
        return nil
    }
    
    func deleteMovie(_ movie: Movie, withCategory category: MoviesCategory) -> CustomError? {
        guard let realm = self.realm else {
            return .realmInstantiationError
        }
        let movie = MovieRealm(movie: movie, category: category)
        do {
            try realm.write {
                realm.delete(movie)
            }
        } catch {
            return .realmDeleteError
        }
        return nil
    }
    
    func deleteMoviesOfCategory(_ category: MoviesCategory) -> CustomError? {
        guard let realm = self.realm else {
            return .realmInstantiationError
        }
        let movies = realm.objects(MovieRealm.self).where {
            $0.category == category.rawValue
        }
        do {
            try realm.write {
                realm.delete(movies)
            }
        } catch {
            return .realmDeleteError
        }
        return nil
    }
    
    func deleteAll() -> CustomError? {
        guard let realm = self.realm else {
            return .realmInstantiationError
        }
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            return .realmDeleteError
        }
        return nil
    }
}
