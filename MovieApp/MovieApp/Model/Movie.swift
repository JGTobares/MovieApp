//
//  Movie.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 13/04/22.
//

import Foundation

struct Movie: Codable{
    
    // MARK: - Constants
    let id: Int?
    let backdropPath: String?
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
    let credits: Credits?
    
    // MARK: - Coding Keys
    enum CodingKeys: String, CodingKey {
        case id, genres, homepage, overview, popularity, runtime, status, tagline, title, credits
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
    }
    
    // MARK: - Functions
    func getGenres() -> String {
        guard let genres = self.genres, genres.count > 0 else {
            return ""
        }
        var genresString = genres[0].name ?? ""
        for index in 1..<genres.count {
            if let genre = genres[index].name {
                genresString += " \(genre)"
            }
        }
        return genresString.trimmingCharacters(in: CharacterSet(charactersIn: " "))
    }
    
    func getDirector() -> String {
        guard let credits = self.credits, let crew = credits.crew, crew.count > 0 else {
            return ""
        }
        return crew.first(where: { $0.job == "Director" })?.name ?? ""
    }
    
    func getFormattedReleaseDate() -> String {
        guard let releaseDate = self.releaseDate else {
            return "N/A"
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: releaseDate) else {
            return "N/A"
        }
        dateFormatter.dateFormat = "MMM d, yyyy"
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: date)
    }
    
    func getRuntimeString() -> String {
        guard let runtime = self.runtime else {
            return "0m"
        }
        let hours = runtime / 60
        let minutes = runtime % 60
        return hours > 0 && minutes > 0 ? "\(hours)h \(minutes)m" : hours > 0 ? "\(hours)h" : "\(minutes)m"
    }
}

struct Genre: Codable {
    let id: Int?
    let name: String?
}

struct Credits: Codable {
    let crew: [Crew]?
}

struct MoviesResponse: Codable {
    let results: [Movie]?
}
