//
//  FavoritesManagerTest.swift
//  MovieAppTests
//
//  Created by Fernando Guerrero on 21/04/22.
//

import Foundation
import XCTest

@testable import MovieApp
class FavoritesManagerTest: XCTestCase {
    
    let manager = FavoritesManager(service: MockRealmService(), baseApiServiceMovie: MockBaseAPIService<Movie>(), baseApiServiceMoviesResponse: MockBaseAPIService<MoviesResponse>())
    
    func testSections() throws {
        manager.favoriteMovies = []
        manager.favoriteTvShows = []
        XCTAssertEqual(0, manager.sections)
        manager.getFavorites()
        manager.favoriteMovies = []
        XCTAssertEqual(1, manager.sections)
        manager.getFavorites()
        manager.favoriteTvShows = []
        XCTAssertEqual(1, manager.sections)
        manager.getFavorites()
        XCTAssertEqual(2, manager.sections)
    }
    
    func testNoFavoritesFlag() throws {
        manager.favoriteMovies = []
        manager.favoriteTvShows = []
        XCTAssertTrue(manager.noFavorites)
        manager.getFavorites()
        manager.favoriteMovies = []
        XCTAssertFalse(manager.noFavorites)
        manager.getFavorites()
        manager.favoriteTvShows = []
        XCTAssertFalse(manager.noFavorites)
        manager.getFavorites()
        XCTAssertFalse(manager.noFavorites)
    }
    
    func testGetFavorites() throws {
        manager.favoriteMovies = []
        manager.favoriteTvShows = []
        XCTAssertTrue(manager.favoriteMovies.isEmpty)
        manager.getFavorites()
        XCTAssertEqual(3, manager.favoriteMovies.count)
    }
    
    func testIsMovieFavorite() throws {
        XCTAssertFalse(manager.isMovieFavorite(id: nil))
        XCTAssertTrue(manager.isMovieFavorite(id: 1))
        XCTAssertFalse(manager.isMovieFavorite(id: 675353))
    }
    
    func testRemoveFavorite() throws {
        manager.getFavorites()
        XCTAssertEqual(3, manager.favoriteMovies.count)
        manager.removeFavorite(id: nil)
        XCTAssertEqual(3, manager.favoriteMovies.count)
        manager.removeFavorite(id: 3)
        XCTAssertEqual(3, manager.favoriteMovies.count)
        manager.removeFavorite(id: 675353)
        XCTAssertEqual(2, manager.favoriteMovies.count)
    }
    
    func testGetRowsOfSection() throws {
        XCTAssertEqual(0, manager.getRowsOfSection(10))
        manager.favoriteMovies = []
        manager.favoriteTvShows = []
        XCTAssertEqual(0, manager.getRowsOfSection(0))
        XCTAssertEqual(0, manager.getRowsOfSection(1))
        manager.getFavorites()
        manager.favoriteMovies = []
        XCTAssertEqual(3, manager.getRowsOfSection(0))
        XCTAssertEqual(3, manager.getRowsOfSection(1))
        manager.getFavorites()
        XCTAssertEqual(3, manager.getRowsOfSection(0))
        XCTAssertEqual(3, manager.getRowsOfSection(1))
    }
    
    func testGetFavorite() throws {
        XCTAssertNil(manager.getFavorite(section: 10, row: 1))
        manager.getFavorites()
        XCTAssertNotNil(manager.getFavorite(section: 0, row:2))
        XCTAssertNotNil(manager.getFavorite(section: 1, row:0))
    }
    
    func testGetTitleOfSection() throws {
        let moviesTitle = Constants.SideMenu.movies
        let tvTitle = Constants.SideMenu.tvShows
        XCTAssertEqual("", manager.getTitleOfSection(10))
        manager.favoriteMovies = []
        manager.favoriteTvShows = []
        XCTAssertEqual(tvTitle, manager.getTitleOfSection(0))
        XCTAssertEqual(tvTitle, manager.getTitleOfSection(1))
        manager.getFavorites()
        manager.favoriteMovies = []
        XCTAssertEqual(tvTitle, manager.getTitleOfSection(0))
        XCTAssertEqual(tvTitle, manager.getTitleOfSection(1))
        manager.getFavorites()
        XCTAssertEqual(moviesTitle, manager.getTitleOfSection(0))
        XCTAssertEqual(tvTitle, manager.getTitleOfSection(1))
    }
}
