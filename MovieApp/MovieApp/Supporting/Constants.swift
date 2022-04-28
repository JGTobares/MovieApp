//
//  Constants.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 15/04/22.
//

import Foundation
import UIKit

struct Constants {
 
    // MARK: - General Constants
    struct General {
        static let cancelLabel = "Cancel"
        static let okLabel = "OK"
        static let internalError = "Internal error"
        static let alertError = "Alert error"
        static let validationError = "Validation error"
        static let inputErrorMessage = "Your input text is wrong. Please input corectly your search query."
        static let errorTitle = "Error!"
    }
    
    // MARK: - API Constants
    struct Api {
        static let baseUrlBundle = "urlBase"
        static let apiKeyBundle = "apiKey"
        static let nowEndpoint = "now_playing"
        static let popularEndpoint = "popular"
        static let upcomingEndpoint = "upcoming"
        static let maxTotalPages = 500
    }
    
    // MARK: Nib Names
    struct Nib {
        static let searchResults = "SearchResultsViewController"
    }
    
    // MARK: - Movie Model Constants
    struct Movie {
        static let dateLocaleDefault = "en_US"
        static let releaseDateFormat = "MMM d, yyyy"
        static let releaseDateAPIFormat = "yyyy-MM-dd"
        static let releaseDateUnknown = "N/A"
        static let creditsJobDirector = "Director"
        static let runtimeHoursFormat = "%dh"
        static let runtimeMinutesFormat = "%dm"
        static let runtimeCompleteFormat = runtimeHoursFormat + " " + runtimeMinutesFormat
        static let trailerSite = "YouTube"
        static let trailerType = "Trailer"
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
        static let trailerErrorMessage = "Couldn't load the movie's trailer."
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
        static let collectionCell = "CustomCollectionViewCell"
        static let tableCell = "CustomTableViewCell"
        static let castLabelFormat = "%@ as %@"
    }
    
    // MARK: - Search for Movie Constants
    struct SearchFor {
        static let dialogTitle = "Search"
        static let dialogMessage = "Name of Movie"
        static let dialogInput = "Input a Movie's name"
        static let searchedForTitle = "Searched for: \"%@\""
    }
    
    // MARK: - Side Menu
    struct SideMenu {
        static let movies = "Movies"
        static let tvShows = "TV Shows"
        static let favorites = "Favorites"
        static let cell = "cell"
        static let main = "Main"
        static let movieVC = "movieVC"
        static let tvShowVC = "tvShowVC"
        static let favoritesVC = "favoritesVC"
        static let darkColor = UIColor(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1)
    }
    
    // MARK: - See All Constants
    struct SeeAll {
        static let categoryTitle = "Category: "
        static let categoryNow = "Movies Now Playing"
        static let categoryPopular = "Popular Movies"
        static let categoryUpcoming = "Upcoming Movies"
    }
    
    // MARK: - Favorites Constants
    struct Favorites {
        static let noFavoritesMessage = "You have no Favorites yet."
    }
    
    // MARK: - Notifications Constants
    struct NotificationNameKeys {
        static let updateFavoriteItem = "updateFavoriteItem"
    }
    
    //MARK: - Network Constants
    struct Network {
        static let updateNetworkStatus = "updateNetworkStatus"
        static let statusOnline = "statusOnline"
        static let statusOffline = "statusOffline"
        static let toastOfflineStatus = "STATUS: NO INTERNET CONNECTION"
        static let errorInit = "Unable to start notifier"
        static let movieHome = "MovieHome"
        static let movieDetail = "MovieDetail"
    }
}
