//
//  MovieDetailsRepositoryTest.swift
//  MovieAppTests
//
//  Created by Fernando Guerrero on 14/04/22.
//

import Foundation
import XCTest

@testable import MovieApp
class MovieDetailsManagerTest: XCTestCase {
    
    let manager = MovieDetailsManager(apiService: MockAPIService())
    
    func testGetMovieDetails() throws {
        manager.movie = nil
        XCTAssertNil(manager.movie)
        manager.getMovieDetails(id: 675353)
        XCTAssertEqual(675353, manager.movie?.id)
        manager.movie = nil
        manager.getMovieDetails(id: nil)
        XCTAssertNil(manager.movie)
    }
}
