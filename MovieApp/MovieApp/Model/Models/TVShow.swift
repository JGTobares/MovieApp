//
//  TVShow.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 29/04/22.
//

import Foundation

struct TVShow: Codable {
    
    // MARK: - Constants
    let id: Int?
    let backdropPath: String?
    let genres: [Genre]?
    let homepage: String?
    let overview: String?
    let posterPath: String?
    let releaseDate: String?
    let runtime: Int?
    let status: String?
    let tagline: String?
    let title: String?
    var credits: Credits?
    var videos: Videos? = nil
    
    // MARK: - Initializers
    init(id: Int?, backdropPath: String?, genres: [Genre]?, homepage: String?,
         overview: String?, posterPath: String?, releaseDate: String?,
         runtime: Int?, status: String?, tagline: String?, title: String?, credits: Credits?) {
        self.id = id
        self.backdropPath = backdropPath
        self.genres = genres
        self.homepage = homepage
        self.overview = overview
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.runtime = runtime
        self.status = status
        self.tagline = tagline
        self.title = title
        self.credits = credits
    }
    
    init(tvShow: TVShowRealm) {
        self.id = tvShow.id
        self.backdropPath = tvShow.backdropPath
        self.genres = tvShow.genres?.split(separator: " ").map { genre in
            Genre(id: nil, name: "\(genre)")
        }
        self.homepage = tvShow.homepage
        self.overview = tvShow.overview
        self.posterPath = tvShow.posterPath
        self.releaseDate = tvShow.releaseDate
        self.runtime = tvShow.runtime
        self.status = tvShow.status
        self.tagline = tvShow.tagline
        self.title = tvShow.title
        let cast: [Cast] = tvShow.cast.map { member in
            return Cast(cast: member)
        }
        self.credits = Credits(crew: [Crew(id: nil, gender: nil, name: tvShow.director, profilePath: nil, job: Constants.Movie.creditsJobDirector)], cast: cast)
    }
    
    // MARK: - Coding Keys
    enum CodingKeys: String, CodingKey {
        case id, genres, homepage, overview, status, tagline, credits, videos
        case runtime = "number_of_seasons"
        case title = "name"
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
        case releaseDate = "first_air_date"
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
    
    func getYouTubeTrailer() -> Video? {
        guard let videos = videos?.results else {
            return nil
        }
        return videos.first(where: { $0.isYouTubeTrailer() })
    }
}

struct TVShowsResponse: Codable {
    
    // MARK: - Constants
    let page: Int?
    let results: [TVShow]?
    let totalPages: Int?
    
    // MARK: - Coding Keys
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
    }
}
