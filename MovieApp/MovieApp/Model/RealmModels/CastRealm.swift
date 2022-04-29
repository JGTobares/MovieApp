//
//  CastRealm.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 26/04/22.
//

import Foundation
import RealmSwift

class CastRealm: Object {
    
    // MARK: - Properties
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String?
    @Persisted var profilePath: String?
    @Persisted var character: String?
    @Persisted(originProperty: "cast") var movie: LinkingObjects<MovieRealm>
    
    convenience init(cast: Cast) {
        self.init()
        self.id = cast.id ?? 0
        self.name = cast.name
        self.profilePath = cast.profilePath
        self.character = cast.character
    }
}
