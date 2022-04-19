//
//  SearchResultsManagerTest.swift
//  MovieAppTests
//
//  Created by Fernando Guerrero on 19/04/22.
//

import Foundation
import XCTest

@testable import MovieApp
class SearchResultsManagerTest: XCTestCase {
    
    let manager = SearchResultsManager(apiService: MockAPIService())
    
    func testGetTitleLabel() throws {
        var title = manager.getTitleLabel(category: .now)
        XCTAssertEqual(title, "Category: Movies Now Playing")
        title = manager.getTitleLabel(category: .popular)
        XCTAssertEqual(title, "Category: Popular Movies")
        title = manager.getTitleLabel(category: .upcoming)
        XCTAssertEqual(title, "Category: Upcoming Movies")
        title = manager.getTitleLabel(category: nil)
        XCTAssertEqual(title, "")
        
    }
    
    func testLoadNowMovies() throws {
        manager.movies = nil
        manager.loadMoviesFromCategory(.now)
        XCTAssertNotNil(manager.movies)
        XCTAssertEqual(manager.movies?.count, 2)
    }
    
    func testLoadPopularMovies() throws {
        manager.movies = nil
        manager.loadMoviesFromCategory(.popular)
        XCTAssertNotNil(manager.movies)
        XCTAssertEqual(manager.movies?.count, 2)
    }
    
    func testLoadUpcomingMovies() throws {
        manager.movies = nil
        manager.loadMoviesFromCategory(.upcoming)
        XCTAssertNotNil(manager.movies)
        XCTAssertEqual(manager.movies?.count, 2)
    }
    
    func testLoadMoviesNoCategory() throws {
        manager.movies = nil
        manager.loadMoviesFromCategory(nil)
        XCTAssertNil(manager.movies)
    }
    
    func testLoadResultSuccess() throws {
        manager.movies = nil
        manager.loadResult(.success([]))
        XCTAssertNotNil(manager.movies)
        XCTAssertEqual(manager.movies?.count, 0)
    }
    
    func testLoadResultFailure() throws {
        manager.movies = nil
        manager.loadResult(.failure(.internalError))
        XCTAssertNil(manager.movies)
    }
}
