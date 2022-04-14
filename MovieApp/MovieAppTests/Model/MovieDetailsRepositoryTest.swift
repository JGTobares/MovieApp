//
//  MovieDetailsRepositoryTest.swift
//  MovieAppTests
//
//  Created by Fernando Guerrero on 14/04/22.
//

import Foundation
import XCTest

@testable import MovieApp
class MovieDetailsRepositoryTest: XCTestCase {
    
    let repository = MovieDetailsRepository(apiService: MockAPIService())
    
    func testGetMovieDetails() throws {
        repository.movie = nil
        XCTAssertNil(repository.movie)
        repository.getMovieDetails(id: 675353)
        XCTAssertEqual(675353, repository.movie?.id)
        repository.movie = nil
        repository.getMovieDetails(id: nil)
        XCTAssertNil(repository.movie)
    }
}
