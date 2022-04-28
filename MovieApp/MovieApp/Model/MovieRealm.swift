//
//  MovieRealm.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 20/04/22.
//

import Foundation
import RealmSwift

class MovieRealm: Object {
    
    // MARK: - Properties
    @Persisted(primaryKey: true) var id: Int
    @Persisted var backdropPath: String
    @Persisted var genres: String
    @Persisted var homepage: String
    @Persisted var overview: String
    @Persisted var rating: Double
    @Persisted var posterPath: String
    @Persisted var releaseDate: String
    @Persisted var runtime: String
    @Persisted var status: String
    @Persisted var tagline: String
    @Persisted var title: String
    @Persisted var director: String
    @Persisted var category: Int?
    @Persisted var favorite: Bool?
    @Persisted var cast: List<CastRealm> = List()
    
    // MARK: - Initializers
    convenience init(movie: Movie) {
        self.init()
        self.id = movie.id ?? 0
        self.backdropPath = movie.backdropPath ?? ""
        self.genres = movie.getGenres()
        self.homepage = movie.homepage ?? ""
        self.overview = movie.overview ?? ""
        self.rating = movie.rating ?? 0
        self.posterPath = movie.posterPath ?? ""
        self.releaseDate = movie.getFormattedReleaseDate()
        self.runtime = movie.getRuntimeString()
        self.status = movie.status ?? ""
        self.tagline = movie.tagline ?? ""
        self.title = movie.title ?? ""
        self.director = movie.getDirector()
        if let cast = movie.credits?.cast {
            self.cast.append(objectsIn: cast.map { member in
                return CastRealm(cast: member)
            })
        }
    }
    
    convenience init(movie: Movie, category: MoviesCategory) {
        self.init(movie: movie)
        self.category = category.rawValue
    }
}
