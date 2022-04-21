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
    
    let movie = MockAPIService().movies[1]
    
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
                              credits: Credits(crew: nil))
        XCTAssertEqual("", movieTest.getDirector())
        movieTest = Movie(id: 1, backdropPath: "", genres: [], homepage: "", overview: "", popularity: 1, posterPath: "", releaseDate: "", runtime: 1, status: "", tagline: "", title: "",
                              credits: Credits(crew: [
                                Crew(id: nil, gender: nil, name: "Shuji Utsumi", profilePath: nil, job: "Executive Producer"),
                                Crew(id: nil, gender: nil, name: "Jeff Fowler", profilePath: nil, job: "")
                              ]))
        XCTAssertEqual("", movieTest.getDirector())
        movieTest = Movie(id: 1, backdropPath: "", genres: [], homepage: "", overview: "", popularity: 1, posterPath: "", releaseDate: "", runtime: 1, status: "", tagline: "", title: "",
                              credits: Credits(crew: [
                                Crew(id: nil, gender: nil, name: "Shuji Utsumi", profilePath: nil, job: "Executive Producer"),
                                Crew(id: nil, gender: nil, name: nil, profilePath: nil, job: "Director")
                              ]))
        XCTAssertEqual("", movieTest.getDirector())
        movieTest = Movie(id: 1, backdropPath: "", genres: [], homepage: "", overview: "", popularity: 1, posterPath: "", releaseDate: "", runtime: 1, status: "", tagline: "", title: "",
                              credits: Credits(crew: [
                                Crew(id: nil, gender: nil, name: "Shuji Utsumi", profilePath: nil, job: "Director"),
                                Crew(id: nil, gender: nil, name: "Jeff Fowler", profilePath: nil, job: "Director")
                              ]))
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
}
