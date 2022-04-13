//
//  Movie.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 13/04/22.
//

import Foundation

struct Movie: Codable {
    
    // MARK: Constants
    let id: Int?
    let genres: [Genre]?
    let homepage: String?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let releaseDate: String?
    let runtime: Int?
    let status: String?
    let tagline: String?
    let title: String?
    
    // MARK: Coding Keys
    enum CodingKeys: String, CodingKey {
        case id, genres, homepage, overview, popularity, runtime, status, tagline, title
        case posterPath = "poster_path"
        case releaseDate = "release_date"
    }
}

struct Genre: Codable {
    let id: Int?
    let name: String?
}

struct MoviesResponse: Codable {
    let results: [Movie]?
}
