//
//  Crew.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 14/04/22.
//

import Foundation

struct Crew: Codable {
    
    // MARK: Constants
    let id: Int?
    let gender: Int?
    let name: String?
    let profilePath: String?
    let job: String?
    
    // MARK: Coding Keys
    enum CodingKeys: String, CodingKey {
        case id, gender, name, job
        case profilePath = "profile_path"
    }
}
