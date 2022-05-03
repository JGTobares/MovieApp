//
//  StorageManager.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 20/04/22.
//

import Foundation
import Reachability

class StorageManager {
    
    // MARK: - Constants
    //1ER MIGRACION
    //let movieManager: MovieManager
    //2DA MIGRACION
    //let detailsManager: MovieDetailsManager
    //3RA MIGRACION
    //let favoritesManager: FavoritesManager
    //4TA MIGRACION
    //let tvShowsManager: TVShowManager
  
    //COLOCAR EN TODOS LOS MANAGER
    let realmRepository: RealmRepository
    let reachability = try! Reachability()
    
    
    // MARK: Initializers
    init() {
        //self.movieManager = MovieManager()
        //self.detailsManager = MovieDetailsManager()
        //self.favoritesManager = FavoritesManager()
        //self.tvShowsManager = TVShowManager()
        self.realmRepository = RealmRepository()
    }
    
    init(realmService: RealmServiceProtocol, baseApiServiceMovie: BaseAPIService<Movie>, baseApiServiceMoviesResponse: BaseAPIService<MoviesResponse>, baseApiServiceTVShow: BaseAPIService<TVShow>, baseApiServicesTVShowList: BaseAPIService<TVShowsResponse>) {
        
        //self.detailsManager = MovieDetailsManager(apiService: baseApiServiceMovie)
        //self.favoritesManager = FavoritesManager(service: realmService)
        //self.tvShowsManager = TVShowManager(apiService: baseApiServiceTVShow, apiServiceList: baseApiServicesTVShowList)
        self.realmRepository = RealmRepository(service: realmService)
    }
    
    // MARK: - Functions
    //COLOCAR EN TODOS LOS MANAGER
    func configureNetwork() {
        do {
            try reachability.startNotifier()
        } catch {
            print(Constants.Network.errorInit)
        }
    }
    
    //ERROR VA A TODOS LOS MANAGER
    func setErrorDelegate(_ delegate: ErrorAlertDelegate) {
        self.realmRepository.errorDelegate = delegate
    }
}
