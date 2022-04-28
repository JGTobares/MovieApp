//
//  MovieResponseRepositoryTest.swift
//  MovieAppTests
//
//  Created by Fernando Guerrero on 28/04/22.
//

import Foundation
import XCTest

@testable import MovieApp
class MovieResponseRepositoryTest: XCTestCase {
    
    let repository = MovieResponseRepository(apiService: MockBaseAPIService<MoviesResponse>())
    
    func testGetListOfMovies() throws {
        repository.getListOfMovies(category: MoviesCategory.now) { result in
            let movies = try! result.get()
            XCTAssertEqual(movies.results?.count, 2)
            XCTAssertEqual(movies.results?[1].id, 675353)
        }
        repository.getListOfMovies(category: MoviesCategory.popular) { result in
            let movies = try! result.get()
            XCTAssertEqual(movies.results?.count, 2)
            XCTAssertEqual(movies.results?[1].id, 675353)
        }
        repository.getListOfMovies(category: MoviesCategory.upcoming) { result in
            let movies = try! result.get()
            XCTAssertEqual(movies.results?.count, 2)
            XCTAssertEqual(movies.results?[1].id, 675353)
        }
    }
    
    func testSearchFor() throws {
        repository.searchFor(query: "", page: 1) { result in
            let movies = try! result.get()
            XCTAssertEqual(movies.results?.count, 2)
            XCTAssertEqual(movies.results?[1].id, 675353)
        }
    }
}
