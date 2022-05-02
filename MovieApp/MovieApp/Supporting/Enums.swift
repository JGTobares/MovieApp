//
//  Enums.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 13/04/22.
//

import Foundation

enum CustomError: String, Error, Equatable {
    case internalError = "Internal Error"
    case urlError = "URL Error"
    case connectionError = "Error connecting with API"
    case authorizationError = "No authorization"
    case notFoundError = "Item Not Found"
    case jsonError = "JSON parsing exception"
    case realmInstantiationError = "Realm DB Error"
    case realmAddError = "Couldn't add Item to Realm"
    case realmUpdateError = "Couldn't update Item in Realm"
    case realmDeleteError = "Couldn't delete Item in Realm"
}

enum MoviesCategory: Int {
    case now = 1
    case popular = 2
    case upcoming = 3
}

enum TVShowsCategory: Int {
    case onTheAir = 1
    case popular = 2

enum FavoritesType {
    case movie(Movie)
    case tvShow(TVShow)
}
