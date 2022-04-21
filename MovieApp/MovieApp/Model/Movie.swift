//
//  Movie.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 13/04/22.
//

import Foundation

struct Movie: Codable {
    
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
    
    // MARK: - Initializers
    init(id: Int?, backdropPath: String?, genres: [Genre]?, homepage: String?,
         overview: String?, popularity: Double?, posterPath: String?, releaseDate: String?,
         runtime: Int?, status: String?, tagline: String?, title: String?, credits: Credits?) {
        self.id = id
        self.backdropPath = backdropPath
        self.genres = genres
        self.homepage = homepage
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.runtime = runtime
        self.status = status
        self.tagline = tagline
        self.title = title
        self.credits = credits
    }
    
    init(movie: MovieRealm) {
        self.id = movie.id
        self.backdropPath = movie.backdropPath
        self.genres = movie.genres.split(separator: " ").map { genre in
            Genre(id: nil, name: "\(genre)")
        }
        self.homepage = movie.homepage
        self.overview = movie.overview
        self.popularity = movie.popularity
        self.posterPath = movie.posterPath
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.Movie.releaseDateFormat
        dateFormatter.locale = Locale(identifier: Constants.Movie.dateLocaleDefault)
        if let date = dateFormatter.date(from: movie.releaseDate) {
            dateFormatter.dateFormat = Constants.Movie.releaseDateAPIFormat
            self.releaseDate = dateFormatter.string(from: date)
        } else {
            self.releaseDate = Constants.Movie.releaseDateUnknown
        }
        let hours = movie.runtime.contains("h") ?
            Int(movie.runtime.split(separator: "h").first?.description ?? "0") : 0
        let minutes = movie.runtime.contains("m") ?
            Int(movie.runtime.split(separator: " ").last?.split(separator: "m").first?.description ?? "0") : 0
        self.runtime = (hours ?? 0) * 60 + (minutes ?? 0)
        self.status = movie.status
        self.tagline = movie.tagline
        self.title = movie.title
        self.credits = Credits(crew: [Crew(id: nil, gender: nil, name: movie.director, profilePath: nil, job: Constants.Movie.creditsJobDirector)])
    }
    
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
        return genresString.trimmingCharacters(in: .whitespaces)
    }
    
    func getDirector() -> String {
        guard let credits = self.credits, let crew = credits.crew, crew.count > 0 else {
            return ""
        }
        return crew.first(where: { $0.job == Constants.Movie.creditsJobDirector })?.name ?? ""
    }
    
    func getFormattedReleaseDate() -> String {
        guard let releaseDate = self.releaseDate else {
            return Constants.Movie.releaseDateUnknown
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.Movie.releaseDateAPIFormat
        guard let date = dateFormatter.date(from: releaseDate) else {
            return Constants.Movie.releaseDateUnknown
        }
        dateFormatter.dateFormat = Constants.Movie.releaseDateFormat
        dateFormatter.locale = Locale(identifier: Constants.Movie.dateLocaleDefault)
        return dateFormatter.string(from: date)
    }
    
    func getRuntimeString() -> String {
        guard let runtime = self.runtime else {
            return String.localizedStringWithFormat(Constants.Movie.runtimeMinutesFormat, 0)
        }
        let hours = runtime / 60
        let minutes = runtime % 60
        return hours > 0 && minutes > 0 ? String.localizedStringWithFormat(Constants.Movie.runtimeCompleteFormat, hours, minutes)
            : hours > 0 ?
                String.localizedStringWithFormat(Constants.Movie.runtimeHoursFormat, hours) :
                String.localizedStringWithFormat(Constants.Movie.runtimeMinutesFormat, minutes)
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
    
    // MARK: - Constants
    let page: Int?
    let results: [Movie]?
    let totalPages: Int?
    
    // MARK: - Coding Keys
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
    }
}
