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
    
    func testSetTotalPages() throws {
        manager.totalPages = nil
        manager.setTotalPages(total: nil)
        XCTAssertNil(manager.totalPages)
        manager.setTotalPages(total: 499)
        XCTAssertEqual(manager.totalPages, 499)
        manager.setTotalPages(total: 4990)
        XCTAssertEqual(manager.totalPages, 500)
    }
    
    func testGetMovieResponse() throws {
        manager.movies = nil
        manager.totalPages = nil
        manager.currentPage = nil
        manager.getMovieResponse(category: .now)
        XCTAssertNotNil(manager.movies)
        XCTAssertEqual(manager.movies?.count, 2)
        XCTAssertNotNil(manager.currentPage)
        XCTAssertEqual(manager.currentPage, 1)
        XCTAssertNotNil(manager.totalPages)
        XCTAssertEqual(manager.totalPages, 10)
    }
    
    func testSearchFor() throws {
        manager.movies = nil
        manager.totalPages = nil
        manager.currentPage = nil
        manager.searchFor(query: "Avengers")
        XCTAssertNotNil(manager.movies)
        XCTAssertEqual(manager.movies?.count, 2)
        XCTAssertNotNil(manager.currentPage)
        XCTAssertEqual(manager.currentPage, 1)
        XCTAssertNotNil(manager.totalPages)
        XCTAssertEqual(manager.totalPages, 10)
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
    
    func testNextPage() throws {
        manager.currentPage = nil
        manager.nextPage()
        XCTAssertNil(manager.currentPage)
        manager.currentPage = 50
        manager.nextPage()
        XCTAssertEqual(manager.currentPage, 51)
    }
    
    func testPreviousPage() throws {
        manager.currentPage = nil
        manager.previousPage()
        XCTAssertNil(manager.currentPage)
        manager.currentPage = 50
        manager.previousPage()
        XCTAssertEqual(manager.currentPage, 49)
    }
    
    func testHasPreviousPage() throws {
        manager.currentPage = nil
        XCTAssertFalse(manager.hasPreviousPage())
        manager.currentPage = 1
        XCTAssertFalse(manager.hasPreviousPage())
        manager.currentPage = 10
        XCTAssertTrue(manager.hasPreviousPage())
    }
    
    func testHasNextPage() throws {
        manager.currentPage = nil
        XCTAssertFalse(manager.hasNextPage())
        manager.currentPage = 10
        manager.totalPages = nil
        XCTAssertFalse(manager.hasNextPage())
        manager.totalPages = 10
        XCTAssertFalse(manager.hasNextPage())
        manager.totalPages = 11
        XCTAssertTrue(manager.hasNextPage())
        
    }
}
