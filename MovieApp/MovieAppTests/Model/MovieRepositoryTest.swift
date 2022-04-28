//
//  MovieRepositoryTest.swift
//  MovieAppTests
//
//  Created by Fernando Guerrero on 28/04/22.
//

import Foundation
import XCTest

@testable import MovieApp
class MovieRepositoryTest: XCTestCase {
    
    let repository = MovieRepository(apiService: MockBaseAPIService<Movie>())
    
    func testGetMovieDetails() throws {
        repository.getMovieDetails(id: 675353) { result in
            let movie = try! result.get()
            XCTAssertEqual(movie.id, 675353)
            XCTAssertEqual(movie.title, "Sonic the Hedgehog 2")
        }
        repository.getMovieDetails(id: nil) { result in
            let movie = try? result.get()
            XCTAssertNil(movie)
        }
        repository.getMovieDetails(id: 1) { result in
            let movie = try? result.get()
            XCTAssertNil(movie)
        }
    }
}
