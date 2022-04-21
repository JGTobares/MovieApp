//
//  Enums.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 13/04/22.
//

import Foundation

enum CustomError: Error, Equatable {
    case internalError
    case urlError
    case connectionError
    case authorizationError
    case notFoundError
    case jsonError
    case realmInstantiationError
    case realmAddError
    case realmUpdateError
    case realmDeleteError
}

enum MoviesCategory: Int {
    case now = 1
    case popular = 2
    case upcoming = 3
}
