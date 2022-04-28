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
    
    let manager = MovieDetailsManager(apiService: MockBaseAPIService())
    
    func testGetMovieDetails() throws {
        manager.movie = nil
        XCTAssertNil(manager.movie)
        manager.getMovieDetails(id: 675353) { _ in }
        XCTAssertEqual(675353, manager.movie?.id)
        manager.movie = nil
        manager.getMovieDetails(id: nil) { _ in }
        XCTAssertNil(manager.movie)
    }
}
