//
//  Constants.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 15/04/22.
//

import Foundation

struct Constants {
 
    // MARK: - General Constants
    struct General {
        static let cancelLabel = "Cancel"
        static let okLabel = "OK"
        static let internalError = "Internal error"
        static let alertError = "Alert error"
        static let validationError = "Validation error"
        static let inputErrorMessage = "Your input text is wrong. Please input corectly your search query."
    }
    
    // MARK: - Movie Details Constants
    struct MovieDetails {
        static let directorLabel = "Director: %@"
        static let emptyImage = "emptyImage"
        static let placeholder = "placeholder"
        static let urlBasePoster = "https://image.tmdb.org/t/p/w500"
        static let urlBaseBackground = "https://image.tmdb.org/t/p/w1280"
    }
    
    // MARK: - Search for Movie Constants
    struct SearchFor {
        static let dialogTitle = "Search"
        static let dialogMessage = "Name of Movie"
        static let dialogInput = "Input a Movie's name"
    }
}
