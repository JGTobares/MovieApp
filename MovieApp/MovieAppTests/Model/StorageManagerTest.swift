//
//  StorageManagerTest.swift
//  MovieAppTests
//
//  Created by Fernando Guerrero on 20/04/22.
//

import Foundation
import XCTest

@testable import MovieApp
class StorageManagerTest: XCTestCase {
    
    let manager = StorageManager(realmService: MockRealmService(), baseApiServiceMovie: MockBaseAPIService<Movie>(), baseApiServiceMoviesResponse: MockBaseAPIService<MoviesResponse>(), baseApiServiceTVShow: MockBaseAPIService<TVShow>())
    
    func testLazyVariables() throws {
        manager.detailsManager.movie = nil
        manager.movieManager.nowMovies = []
        manager.movieManager.popularMovies = []
        manager.movieManager.upcomingMovies = []
        XCTAssertEqual(0, manager.nowMovieCount)
        XCTAssertEqual(0, manager.popularMovieCount)
        XCTAssertEqual(0, manager.upcomingMovieCount)
        manager.getMovies()
        XCTAssertEqual(2, manager.nowMovieCount)
        XCTAssertEqual(2, manager.popularMovieCount)
        XCTAssertEqual(2, manager.upcomingMovieCount)
        manager.detailsManager.cast = nil
        XCTAssertTrue(manager.movieCast.isEmpty)
        XCTAssertEqual(manager.castCount, 0)
        manager.detailsManager.cast = []
        XCTAssertTrue(manager.movieCast.isEmpty)
        XCTAssertEqual(manager.castCount, 0)
        manager.getMovieDetails(id: 675353)
        XCTAssertFalse(manager.movieCast.isEmpty)
        XCTAssertEqual(manager.castCount, 1)
        XCTAssertEqual(manager.movieCast[0].id, 222121)
    }
    
    func testGetMovies() throws {
        manager.getMovies()
        XCTAssertNotNil(manager.movieManager.nowMovies)
        XCTAssertNotNil(manager.movieManager.popularMovies)
        XCTAssertNotNil(manager.movieManager.upcomingMovies)
        XCTAssertFalse(manager.movieManager.nowMovies.isEmpty)
        XCTAssertFalse(manager.movieManager.popularMovies.isEmpty)
        XCTAssertFalse(manager.movieManager.upcomingMovies.isEmpty)
    }
    
    func testGetNowMovie() throws {
        manager.getMovies()
        XCTAssertNotNil(manager.movieManager.nowMovies)
        XCTAssertEqual(675353, manager.getNowMovie(at: 1).id)
    }
    
    func testGetPopularMovie() throws {
        manager.getMovies()
        XCTAssertNotNil(manager.movieManager.popularMovies)
        XCTAssertEqual(675353, manager.getNowMovie(at: 1).id)
    }
    
    func testGetUpcomingMovie() throws {
        manager.getMovies()
        XCTAssertNotNil(manager.movieManager.upcomingMovies)
        XCTAssertEqual(675353, manager.getNowMovie(at: 1).id)
    }
    
    func testGetMovieCast() throws {
        manager.getMovieDetails(id: 675353)
        XCTAssertTrue(manager.castCount > 0)
        let cast = manager.getMovieCast(at: 0)
        XCTAssertEqual(cast.id, 222121)
    }
    
    func testGetMovieDetails() throws {
        manager.getMovieDetails(id: 675353)
        XCTAssertNotNil(manager.detailsManager.movie)
        XCTAssertEqual(675353, manager.detailsManager.movie?.id)
    }
    
    func testGetMovieDetailsRealm() throws {
        manager.detailsManager.movie = nil
        let _ = manager.getMovieDetailsRealm(id: nil)
        XCTAssertNil(manager.detailsManager.movie)
        let _ = manager.getMovieDetailsRealm(id: 1)
        XCTAssertNotNil(manager.detailsManager.movie)
        XCTAssertEqual(675353, manager.detailsManager.movie?.id)
    }
    
    func testGetMoviesRealm() throws {
        manager.getMoviesRealm()
        XCTAssertNotNil(manager.movieManager.nowMovies)
        XCTAssertNotNil(manager.movieManager.popularMovies)
        XCTAssertNotNil(manager.movieManager.upcomingMovies)
        XCTAssertFalse(manager.movieManager.nowMovies.isEmpty)
        XCTAssertFalse(manager.movieManager.popularMovies.isEmpty)
        XCTAssertFalse(manager.movieManager.upcomingMovies.isEmpty)
    }
}
