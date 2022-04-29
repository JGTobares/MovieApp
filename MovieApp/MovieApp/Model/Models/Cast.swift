//
//  Cast.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 26/04/22.
//

import Foundation

struct Cast: Codable {
    
    // MARK: Constants
    let id: Int?
    let name: String?
    let profilePath: String?
    let character: String?
    
    // MARK: Coding Keys
    enum CodingKeys: String, CodingKey {
        case id, name, character
        case profilePath = "profile_path"
    }
    
    // MARK: Initializers
    init(id: Int?, name: String?, profilePath: String?, character: String?) {
        self.id = id
        self.name = name
        self.profilePath = profilePath
        self.character = character
    }
    
    init(cast: CastRealm) {
        self.id = cast.id
        self.name = cast.name
        self.profilePath = cast.profilePath
        self.character = nil
    }
}
