//
//  RealmService.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 20/04/22.
//

import Foundation
import RealmSwift

class RealmService {
    
    // MARK: - Constants
    let realm = try? Realm()
    
    
    // MARK: - Create
    func addMovie(_ movie: Movie) -> CustomError? {
        guard let realm = self.realm else {
            return .realmInstantiationError
        }
        let movie = MovieRealm(movie: movie)
        do {
            try realm.write {
                realm.add(movie)
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
        let movies = movies.map {
            MovieRealm(movie: $0, category: category)
        }
        do {
            try realm.write {
                realm.add(movies)
            }
        } catch {
            return .realmAddError
        }
        return nil
    }
    
    // MARK: - Read
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
    
    // MARK: - Update
    func updateMovie(_ movie: Movie, byID id: Int?) -> CustomError? {
        guard let realm = self.realm else {
            return .realmInstantiationError
        }
        let movie = MovieRealm(movie: movie)
        do {
            try realm.write {
                realm.add(movie, update: .modified)
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
        let movie = MovieRealm(movie: movie)
        do {
            try realm.write {
                realm.delete(movie)
            }
        } catch {
            return .realmDeleteError
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
}
