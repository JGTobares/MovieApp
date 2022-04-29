//
//  MovieRealmManagerTest.swift
//  MovieAppTests
//
//  Created by Fernando Guerrero on 20/04/22.
//

import Foundation
import XCTest

@testable import MovieApp
class RealmManagerTest: XCTestCase {
    
    let manager = RealmManager(service: MockRealmService())
    
    func testGetMovieDetails() throws {
        XCTAssertNil(manager.getMovieDetails(id: nil))
        let movie = manager.getMovieDetails(id: 1)
        XCTAssertEqual(675353, movie?.id)
    }
    
    func testGetMovieLists() throws {
        XCTAssertNil(manager.getMovieList(category: nil))
        let movie = manager.getMovieList(category: MoviesCategory.now)
        XCTAssertEqual(3, movie?.count)
    }
    
    func testGetMovieOffline() throws {
        let movie = manager.getMovieOffline()
        XCTAssertEqual(675353, movie?.id)
    }
}
