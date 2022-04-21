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
    
    let manager = StorageManager(apiService: MockAPIService(), realmService: MockRealmService())
    
    func testLazyVariables() throws {
        manager.movieManager.bannerMovie = nil
        manager.movieManager.nowMovies = []
        manager.movieManager.popularMovies = []
        manager.movieManager.upcomingMovies = []
        XCTAssertNil(manager.movieBanner)
        XCTAssertEqual(0, manager.nowMovieCount)
        XCTAssertEqual(0, manager.popularMovieCount)
        XCTAssertEqual(0, manager.upcomingMovieCount)
        manager.getMovies()
        XCTAssertNotNil(manager.movieBanner)
        XCTAssertEqual(2, manager.nowMovieCount)
        XCTAssertEqual(2, manager.popularMovieCount)
        XCTAssertEqual(2, manager.upcomingMovieCount)
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
    
    func testGetMovieDetails() throws {
        manager.getMovieDetails(id: 1)
        XCTAssertNotNil(manager.detailsManager.movie)
        XCTAssertEqual(675353, manager.detailsManager.movie?.id)
    }
    
    func testGetMovieDetailsRealm() throws {
        manager.detailsManager.movie = nil
        manager.getMovieDetailsRealm(id: nil)
        XCTAssertNil(manager.detailsManager.movie)
        manager.getMovieDetailsRealm(id: 1)
        XCTAssertNotNil(manager.detailsManager.movie)
        XCTAssertEqual(675353, manager.detailsManager.movie?.id)
    }
}
