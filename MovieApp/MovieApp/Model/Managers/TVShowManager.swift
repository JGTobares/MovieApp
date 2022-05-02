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
    let repositoryList: TVShowsResponseRepository
    
    // MARK: - Variables
    var onTheAirList: [TVShow] = []
    var popularList: [TVShow] = []
    var bannerShowID: Int?
    var bannerOfflineShowID: Int?
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
    var tvShowsDelegate: TVShowManagerDelegate?
    var detailsDelegate: TVShowDetailsViewControllerDelegate?
    var errorDelegate: ErrorAlertDelegate? {
        return self.detailsDelegate as? ErrorAlertDelegate
    }
    
    // MARK: - Initializers
    init() {
        self.repository = TVShowRepository()
        self.repositoryList = TVShowsResponseRepository()
    }
    
    init(apiService: BaseAPIService<TVShow>, apiServiceList: BaseAPIService<TVShowsResponse>) {
        self.repository = TVShowRepository(apiService: apiService)
        self.repositoryList = TVShowsResponseRepository(apiService: apiServiceList)
    }
    

    // MARK: - Functions
    func getTVShowList(category: TVShowsCategory, completion: @escaping ([TVShow]) -> Void) {
        self.repositoryList.getListOfTVSHows(category: category) { result in
            switch result {
            case .success(let tvShows):
                guard let result = tvShows.results else { return }
                if category == .onTheAir {
                self.onTheAirList = result
                self.tvShowsDelegate?.onTheAirLoaded()
                self.bannerShowID = result.randomElement()?.id
                } else {
                self.popularList = result
                self.tvShowsDelegate?.onPopularLoaded()
                }
                completion(result)
                break
            case .failure(let error):
                self.errorDelegate?.showAlertMessage(title: Constants.General.errorTitle, message: error.rawValue)
            }
        }
    }
    
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
