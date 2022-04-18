//
//  MovieManagerTest.swift
//  MovieAppTests
//
//  Created by Julio Gabriel Tobares on 18/04/2022.
//

import Foundation
import XCTest

@testable import MovieApp
class MovieManagerTest: XCTestCase {
    
    let manager = MovieManager(apiService: MockAPIService())
    
    func testLoadNowMovies() throws {
        manager.loadNowMovies()
        XCTAssertNotNil(manager.nowMovies)
        XCTAssertEqual(manager.nowMovies.count, manager.nowMovieCount)
    }
    
    func testLoadPopularMovies() throws {
        manager.loadPopularMovies()
        XCTAssertNotNil(manager.popularMovies)
        XCTAssertEqual(manager.popularMovies.count, manager.popularMovieCount)
    }
    
    func testLoadUpcomingMovies() throws {
        manager.loadUpcomingMovies()
        XCTAssertNotNil(manager.upcomingMovies)
        XCTAssertEqual(manager.upcomingMovies.count, manager.upcomingMovieCount)
    }
    
}
