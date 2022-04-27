//
//  Video.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 25/04/22.
//

import Foundation

struct Video: Codable {
    
    // MARK: - Constants
    let key: String?
    let site: String?
    let type: String?
    let official: Bool?
    
    // MARK: - Functions
    func isYouTubeTrailer() -> Bool {
        guard let site = site, let type = type else {
            return false
        }
        return site == Constants.Movie.trailerSite && type == Constants.Movie.trailerType
    }
}
