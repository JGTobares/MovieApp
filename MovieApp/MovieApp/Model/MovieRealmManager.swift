//
//  MovieRealmManager.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 20/04/22.
//

import Foundation

class MovieRealmManager {
    
    // MARK: - Constants
    let service: RealmServiceProtocol
    
    
    // MARK: - Initializers
    init() {
        service = RealmService()
    }
    
    init(service: RealmServiceProtocol) {
        self.service = service
    }
    
    // MARK: - Functions
    func getMovieDetails(id: Int?) -> MovieRealm? {
        switch self.service.getMovieByID(id) {
        case .success(let movie):
            return movie
        case .failure(let error):
            print(error.localizedDescription)
        }
        return nil
    }
}
