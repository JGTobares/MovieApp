//
//  TVShowRealm.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 29/04/22.
//

import Foundation
import RealmSwift

class TVShowRealm: Object {
    
    // MARK: - Properties
    @Persisted(primaryKey: true) var id: Int
    @Persisted var backdropPath: String?
    @Persisted var genres: String?
    @Persisted var homepage: String?
    @Persisted var overview: String?
    @Persisted var posterPath: String?
    @Persisted var releaseDate: String?
    @Persisted var runtime: Int?
    @Persisted var status: String?
    @Persisted var tagline: String?
    @Persisted var title: String?
    @Persisted var director: String?
    @Persisted var favorite: Bool?
    @Persisted var category: Int?
    @Persisted var cast: List<CastRealm> = List()
    
    // MARK: - Initializers
    convenience init(tvShow: TVShow) {
        self.init()
        self.id = tvShow.id ?? 0
        self.backdropPath = tvShow.backdropPath
        self.genres = tvShow.getGenres()
        self.homepage = tvShow.homepage
        self.overview = tvShow.overview
        self.posterPath = tvShow.posterPath
        self.releaseDate = tvShow.releaseDate
        self.runtime = tvShow.runtime
        self.status = tvShow.status
        self.tagline = tvShow.tagline
        self.title = tvShow.title
        self.director = tvShow.getDirector()
        if let cast = tvShow.credits?.cast {
            self.cast.append(objectsIn: cast.map { member in
                return CastRealm(cast: member)
            })
        }
    }
    
    convenience init(show: TVShow, category: TVShowsCategory) {
        self.init(tvShow: show)
        self.category = category.rawValue
    }
}
