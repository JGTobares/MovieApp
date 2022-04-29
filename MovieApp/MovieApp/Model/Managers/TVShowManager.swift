//
//  TVShowManager.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 29/04/22.
//

import Foundation

class TVShowManager {
    
    // MARK: - Constants
    let repository: TVShowRepository
    
    
    // MARK: - Variables
    var tvShow: TVShow? {
        didSet {
            if let tvShow = tvShow {
                self.detailsDelegate?.didSetTVShow(tvShow)
                self.cast = tvShow.credits?.cast
            }
        }
    }
    var cast: [Cast]? {
        didSet {
            if let cast = cast {
                self.detailsDelegate?.didSetCast(cast)
            }
        }
    }
    var detailsDelegate: TVShowDetailsViewControllerDelegate?
    var errorDelegate: ErrorAlertDelegate? {
        return self.detailsDelegate as? ErrorAlertDelegate
    }
    
    // MARK: - Initializers
    init() {
        self.repository = TVShowRepository()
    }
    
    init(apiService: BaseAPIService<TVShow>) {
        self.repository = TVShowRepository(apiService: apiService)
    }
    
    // MARK: - Functions
    func getTVShowDetails(id: Int?, completion: @escaping (TVShow) -> Void) {
        self.repository.getTVShowDetails(id: id) { result in
            switch result {
            case .success(let tvShow):
                self.tvShow = tvShow
                completion(tvShow)
                break
            case .failure(let error):
                self.errorDelegate?.showAlertMessage(title: Constants.General.errorTitle, message: error.rawValue)
            }
        }
    }
}
