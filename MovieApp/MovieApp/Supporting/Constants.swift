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
        static let releaseDateLabel = "Release Date: %@"
        static let runtimeLabel = "Runtime: %@"
        static let statusLabel = "Status: %@"
        static let statusUnknown = "Unknown"
        static let infoTabTag = 111
        static let castTabTag = 222
        static let trailerTabTag = 333
    }
    
    // MARK: - Images Constants
    struct Images {
        static let emptyImage = "emptyImage"
        static let placeholder = "placeholder"
    }
    
    // MARK: - URL Constants
    struct Url {
        static let urlBasePoster = "https://image.tmdb.org/t/p/w500"
        static let urlBaseBackground = "https://image.tmdb.org/t/p/w1280"
    }
    
    // MARK: - Cell Constants
    struct Cell {
        static let width = 120
        static let height = 230
    }
    
    // MARK: - Search for Movie Constants
    struct SearchFor {
        static let dialogTitle = "Search"
        static let dialogMessage = "Name of Movie"
        static let dialogInput = "Input a Movie's name"
    }
    
    // MARK: - Side Menu
    struct SideMenu {
        static let movies = "Movies"
        static let tvShows = "TV Shows"
        static let favorites = "Favorites"
    }
}
