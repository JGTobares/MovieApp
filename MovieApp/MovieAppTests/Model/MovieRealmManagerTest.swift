//
//  MovieRealmManagerTest.swift
//  MovieAppTests
//
//  Created by Fernando Guerrero on 20/04/22.
//

import Foundation
import XCTest

@testable import MovieApp
class MovieRealmManagerTest: XCTestCase {
    
    let manager = MovieRealmManager(service: MockRealmService())
    
    func testGetMovieDetails() throws {
        XCTAssertNil(manager.getMovieDetails(id: nil))
        let movie = manager.getMovieDetails(id: 1)
        XCTAssertEqual(675353, movie?.id)
    }
}
