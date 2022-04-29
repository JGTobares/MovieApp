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
