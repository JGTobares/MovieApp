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
}
