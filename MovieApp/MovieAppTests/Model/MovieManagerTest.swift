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
        manager.loadNowMovies { movies in
            self.manager.nowMovies = movies
        }
        XCTAssertNotNil(manager.nowMovies)
        XCTAssertEqual(manager.nowMovies.count, 2)
    }
    
    func testLoadPopularMovies() throws {
        manager.loadPopularMovies { movies in
            self.manager.popularMovies = movies
        }
        XCTAssertNotNil(manager.popularMovies)
        XCTAssertEqual(manager.popularMovies.count, 2)
    }
    
    func testLoadUpcomingMovies() throws {
        manager.loadUpcomingMovies { movies in
            self.manager.upcomingMovies = movies
        }
        XCTAssertNotNil(manager.upcomingMovies)
        XCTAssertEqual(manager.upcomingMovies.count, 2)
    }
    
}
