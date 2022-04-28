//
//  MovieTest.swift
//  MovieAppTests
//
//  Created by Fernando Guerrero on 14/04/22.
//

import Foundation
import XCTest

@testable import MovieApp
class MovieTest: XCTestCase {
    
    var movie = MockBaseAPIService<Movie>().movies[1]
    
    func testProperties() throws {
        XCTAssertEqual(675353, movie.id)
        XCTAssertEqual("/egoyMDLqCxzjnSrWOz50uLlJWmD.jpg", movie.backdropPath)
        XCTAssertEqual(4, movie.genres?.count)
        XCTAssertEqual(28, movie.genres?.first?.id)
        XCTAssertEqual("Family", movie.genres?.last?.name)
        XCTAssertEqual("https://www.sonicthehedgehogmovie.com", movie.homepage)
        XCTAssertEqual("... Sonic is eager to prove he has what it takes to be a true hero...", movie.overview)
        XCTAssertEqual(6401.627, movie.popularity)
        XCTAssertEqual("/6DrHO1jr3qVrViUO6s6kFiAGM7.jpg", movie.posterPath)
        XCTAssertEqual("2022-03-30", movie.releaseDate)
        XCTAssertEqual(122, movie.runtime)
        XCTAssertEqual("Released", movie.status)
        XCTAssertEqual("Welcome to the next level.", movie.tagline)
        XCTAssertEqual("Sonic the Hedgehog 2", movie.title)
        XCTAssertEqual(2, movie.credits?.crew?.count)
        XCTAssertEqual(3346056, movie.credits?.crew?.first?.id)
        XCTAssertEqual(0, movie.credits?.crew?.first?.gender)
        XCTAssertEqual("Shuji Utsumi", movie.credits?.crew?.first?.name)
        XCTAssertEqual("/wExdubFgeBkEUP8MojKPKoOcgdZ.jpg", movie.credits?.crew?.last?.profilePath)
        XCTAssertEqual("Director", movie.credits?.crew?.last?.job)
    }
    
    func testPropertiesRealm() throws {
        let movieRealm = MovieRealm(movie: self.movie)
        let movie = Movie(movie: movieRealm)
        XCTAssertEqual(675353, movie.id)
        XCTAssertEqual("/egoyMDLqCxzjnSrWOz50uLlJWmD.jpg", movie.backdropPath)
        XCTAssertEqual("Action Science Fiction Comedy Family", movie.getGenres())
        XCTAssertEqual(nil, movie.genres?.first?.id)
        XCTAssertEqual("Family", movie.genres?.last?.name)
        XCTAssertEqual("https://www.sonicthehedgehogmovie.com", movie.homepage)
        XCTAssertEqual("... Sonic is eager to prove he has what it takes to be a true hero...", movie.overview)
        XCTAssertEqual(6401.627, movie.popularity)
        XCTAssertEqual("/6DrHO1jr3qVrViUO6s6kFiAGM7.jpg", movie.posterPath)
        XCTAssertEqual("2022-03-30", movie.releaseDate)
        XCTAssertEqual(122, movie.runtime)
        XCTAssertEqual("Released", movie.status)
        XCTAssertEqual("Welcome to the next level.", movie.tagline)
        XCTAssertEqual("Sonic the Hedgehog 2", movie.title)
        XCTAssertEqual(1, movie.credits?.crew?.count)
        XCTAssertEqual("Jeff Fowler", movie.credits?.crew?.first?.name)
        XCTAssertEqual("Director", movie.credits?.crew?.last?.job)
    }
    
    func testGetGenres() throws {
        XCTAssertEqual("Action Science Fiction Comedy Family", movie.getGenres())
        var movieTest = Movie(id: 1, backdropPath: "", genres: [], homepage: "", overview: "", popularity: 1, posterPath: "", releaseDate: "", runtime: 1, status: "", tagline: "", title: "", credits: nil)
        XCTAssertEqual("", movieTest.getGenres())
        movieTest = Movie(id: 1, backdropPath: "", genres: nil, homepage: "", overview: "", popularity: 1, posterPath: "", releaseDate: "", runtime: 1, status: "", tagline: "", title: "", credits: nil)
        XCTAssertEqual("", movieTest.getGenres())
        movieTest = Movie(id: 1, backdropPath: "", genres: [Genre(id: 28, name: "Action")],
                          homepage: "", overview: "", popularity: 1, posterPath: "", releaseDate: "", runtime: 1, status: "", tagline: "", title: "", credits: nil)
        XCTAssertEqual("Action", movieTest.getGenres())
        movieTest = Movie(id: 1, backdropPath: "", genres: [Genre(id: 28, name: "Action"), Genre(id: 28, name: "Family")],
                          homepage: "", overview: "", popularity: 1, posterPath: "", releaseDate: "", runtime: 1, status: "", tagline: "", title: "", credits: nil)
        XCTAssertEqual("Action Family", movieTest.getGenres())
        movieTest = Movie(id: 1, backdropPath: "", genres: [Genre(id: 28, name: nil), Genre(id: 28, name: "Family")],
                          homepage: "", overview: "", popularity: 1, posterPath: "", releaseDate: "", runtime: 1, status: "", tagline: "", title: "", credits: nil)
        XCTAssertEqual("Family", movieTest.getGenres())
        movieTest = Movie(id: 1, backdropPath: "", genres: [Genre(id: 28, name: "Action"), Genre(id: 28, name: nil), Genre(id: 28, name: "Family")],
                          homepage: "", overview: "", popularity: 1, posterPath: "", releaseDate: "", runtime: 1, status: "", tagline: "", title: "", credits: nil)
        XCTAssertEqual("Action Family", movieTest.getGenres())
    }
    
    func testGetDirector() throws {
        XCTAssertEqual("Jeff Fowler", movie.getDirector())
        var movieTest = Movie(id: 1, backdropPath: "", genres: [], homepage: "", overview: "", popularity: 1, posterPath: "", releaseDate: "", runtime: 1, status: "", tagline: "", title: "",
                              credits: nil)
        XCTAssertEqual("", movieTest.getDirector())
        movieTest = Movie(id: 1, backdropPath: "", genres: [], homepage: "", overview: "", popularity: 1, posterPath: "", releaseDate: "", runtime: 1, status: "", tagline: "", title: "",
                              credits: Credits(crew: nil, cast: nil))
        XCTAssertEqual("", movieTest.getDirector())
        movieTest = Movie(id: 1, backdropPath: "", genres: [], homepage: "", overview: "", popularity: 1, posterPath: "", releaseDate: "", runtime: 1, status: "", tagline: "", title: "",
                              credits: Credits(crew: [
                                Crew(id: nil, gender: nil, name: "Shuji Utsumi", profilePath: nil, job: "Executive Producer"),
                                Crew(id: nil, gender: nil, name: "Jeff Fowler", profilePath: nil, job: "")
                              ], cast: nil))
        XCTAssertEqual("", movieTest.getDirector())
        movieTest = Movie(id: 1, backdropPath: "", genres: [], homepage: "", overview: "", popularity: 1, posterPath: "", releaseDate: "", runtime: 1, status: "", tagline: "", title: "",
                              credits: Credits(crew: [
                                Crew(id: nil, gender: nil, name: "Shuji Utsumi", profilePath: nil, job: "Executive Producer"),
                                Crew(id: nil, gender: nil, name: nil, profilePath: nil, job: "Director")
                              ], cast: nil))
        XCTAssertEqual("", movieTest.getDirector())
        movieTest = Movie(id: 1, backdropPath: "", genres: [], homepage: "", overview: "", popularity: 1, posterPath: "", releaseDate: "", runtime: 1, status: "", tagline: "", title: "",
                              credits: Credits(crew: [
                                Crew(id: nil, gender: nil, name: "Shuji Utsumi", profilePath: nil, job: "Director"),
                                Crew(id: nil, gender: nil, name: "Jeff Fowler", profilePath: nil, job: "Director")
                              ], cast: nil))
        XCTAssertEqual("Shuji Utsumi", movieTest.getDirector())
    }
    
    func testGetFormattedReleaseDate() throws {
        XCTAssertEqual("Mar 30, 2022", movie.getFormattedReleaseDate())
        var movieTest = Movie(id: 1, backdropPath: "", genres: [], homepage: "", overview: "", popularity: 1, posterPath: "", releaseDate: "", runtime: 0, status: "", tagline: "", title: "", credits: nil)
        XCTAssertEqual("N/A", movieTest.getFormattedReleaseDate())
        movieTest = Movie(id: 1, backdropPath: "", genres: [], homepage: "", overview: "", popularity: 1, posterPath: "", releaseDate: nil, runtime: 0, status: "", tagline: "", title: "", credits: nil)
        XCTAssertEqual("N/A", movieTest.getFormattedReleaseDate())
    }
    
    func testGetRuntimeString() throws {
        XCTAssertEqual("2h 2m", movie.getRuntimeString())
        var movieTest = Movie(id: 1, backdropPath: "", genres: [], homepage: "", overview: "", popularity: 1, posterPath: "", releaseDate: "", runtime: 120, status: "", tagline: "", title: "", credits: nil)
        XCTAssertEqual("2h", movieTest.getRuntimeString())
        movieTest = Movie(id: 1, backdropPath: "", genres: [], homepage: "", overview: "", popularity: 1, posterPath: "", releaseDate: "", runtime: 59, status: "", tagline: "", title: "", credits: nil)
        XCTAssertEqual("59m", movieTest.getRuntimeString())
        movieTest = Movie(id: 1, backdropPath: "", genres: [], homepage: "", overview: "", popularity: 1, posterPath: "", releaseDate: "", runtime: 0, status: "", tagline: "", title: "", credits: nil)
        XCTAssertEqual("0m", movieTest.getRuntimeString())
        movieTest = Movie(id: 1, backdropPath: "", genres: [], homepage: "", overview: "", popularity: 1, posterPath: "", releaseDate: "", runtime: nil, status: "", tagline: "", title: "", credits: nil)
        XCTAssertEqual("0m", movieTest.getRuntimeString())
    }
    
    func testIsYoutubeTrailer() throws {
        var video = Video(key: "", site: nil, type: nil, official: true)
        XCTAssertFalse(video.isYouTubeTrailer())
        video = Video(key: "", site: "YouTube", type: nil, official: true)
        XCTAssertFalse(video.isYouTubeTrailer())
        video = Video(key: "", site: nil, type: "Trailer", official: true)
        XCTAssertFalse(video.isYouTubeTrailer())
        video = Video(key: "", site: "youtube", type: "Trailer", official: true)
        XCTAssertFalse(video.isYouTubeTrailer())
        video = Video(key: "", site: "YouTube", type: "teaser", official: true)
        XCTAssertFalse(video.isYouTubeTrailer())
        video = Video(key: "", site: "YouTube", type: "Trailer", official: true)
        XCTAssertTrue(video.isYouTubeTrailer())
    }
    
    func testGetYouTubeTrailer() throws {
        let trailer = Video(key: "1", site: "YouTube", type: "Trailer", official: true)
        let finalTrailer = Video(key: "2", site: "YouTube", type: "Trailer", official: true)
        let notTrailer = Video(key: "", site: "YouTube", type: "Teaser", official: true)
        XCTAssertNil(movie.getYouTubeTrailer())
        movie.videos = Videos(results: nil)
        XCTAssertNil(movie.getYouTubeTrailer())
        movie.videos = Videos(results: [])
        XCTAssertNil(movie.getYouTubeTrailer())
        movie.videos = Videos(results: [notTrailer])
        XCTAssertNil(movie.getYouTubeTrailer())
        movie.videos = Videos(results: [notTrailer, trailer])
        XCTAssertNotNil(movie.getYouTubeTrailer())
        movie.videos = Videos(results: [notTrailer, trailer, finalTrailer])
        XCTAssertEqual("1", movie.getYouTubeTrailer()?.key)
    }
}
