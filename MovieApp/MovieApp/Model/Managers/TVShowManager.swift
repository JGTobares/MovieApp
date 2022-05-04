//
//  TVShowManager.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 29/04/22.
//

import Foundation
import Reachability

class TVShowManager {
    
    // MARK: - Constants
    let repository: TVShowRepository
    let repositoryList: TVShowsResponseRepository
    let realmRepository: RealmRepository
    let reachability = try! Reachability()
    
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
    var castCount: Int {
        return self.cast?.count ?? 0
    }
    var tvShowsDelegate: TVShowManagerDelegate?
    var detailsDelegate: TVShowDetailsViewControllerDelegate?
    var errorDelegate: ErrorAlertDelegate? {
        return self.detailsDelegate as? ErrorAlertDelegate
    }
    var tvShowBanner: TVShow! {
        return self.tvShow
    }
    var onTheAirTVShowCount: Int {
        return self.onTheAirList.count
    }
    var popularTVShowCount: Int {
        return self.popularList.count
    }
    
    // MARK: - Initializers
    init() {
        self.repository = TVShowRepository()
        self.repositoryList = TVShowsResponseRepository()
        self.realmRepository = RealmRepository()
    }
    
    init(apiService: BaseAPIService<TVShow>, apiServiceList: BaseAPIService<TVShowsResponse>, service: RealmServiceProtocol, baseApiServiceMovie: BaseAPIService<Movie>, baseApiServiceMoviesResponse: BaseAPIService<MoviesResponse>) {
        self.repository = TVShowRepository(apiService: apiService)
        self.repositoryList = TVShowsResponseRepository(apiService: apiServiceList)
        self.realmRepository = RealmRepository(service: service)
    }
    /*
    func setDetailsDelegate(_ delegate: TVShowDetailsViewControllerDelegate) {
        self.detailsDelegate = delegate
    }
    */
    func setTVShowsDelegate(_ delegate: TVShowManagerDelegate) {
        self.tvShowsDelegate = delegate
    }
    

    // MARK: - Functions
    func configureNetwork() {
        do {
            try reachability.startNotifier()
        } catch {
            print(Constants.Network.errorInit)
        }
    }
    
    func getTVShows() {
        reachability.whenReachable = { _ in
            self.getTVShowsAPI()
        }
        
        reachability.whenUnreachable = { _ in
            self.getTVShowsRealm()
            NotificationCenter.default.post(name: Notification.Name(Constants.Network.updateNetworkStatus), object: nil, userInfo: [Constants.Network.updateNetworkStatus : Constants.Network.statusOffline])
        }
        self.configureNetwork()
    }
    
    func getData(tvShowID: Int?) {
        reachability.whenReachable = { _ in
            self.getTVShow(id: tvShowID)
        }

        reachability.whenUnreachable = { _ in
            if !self.getTVShowRealm(id: tvShowID) {
                NotificationCenter.default.post(name: Notification.Name(Constants.Network.updateNetworkStatus), object: nil, userInfo: [Constants.Network.updateNetworkStatus : Constants.Network.statusOffline])
            }
        }
        self.configureNetwork()
    }
    
    //MARK: - TVShow Lists
    func getTVShowsAPI() {
        self.getTVShowList(category: .onTheAir) { onTheAirShows in
            DispatchQueue.main.async {
                self.realmRepository.addTVShows(shows: onTheAirShows, category: TVShowsCategory.onTheAir)
                self.getTVShow(id: self.bannerShowID)
            }
        }
        self.getTVShowList(category: .popular) { popularShows in
            DispatchQueue.main.async {
                self.realmRepository.addTVShows(shows: popularShows, category: TVShowsCategory.popular)
            }
        }
    }
    
    func getTVShowsRealm() {
        guard let onAirList = self.realmRepository.getTVShowList(category: TVShowsCategory.onTheAir) else {
            return
        }
        self.onTheAirList = onAirList
        self.tvShow = self.realmRepository.getTVShowOffline()
        guard let popularList = self.realmRepository.getTVShowList(category: TVShowsCategory.popular) else {
            return
        }
        self.popularList = popularList
        self.tvShowsDelegate?.onTheAirLoaded()
        self.tvShowsDelegate?.onPopularLoaded()
    }
    
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
    
    //MARK: - TVShow Details
    func getTVShow(id: Int?) {
        self.getTVShowDetails(id: id) { tvShow in
            DispatchQueue.main.async {
                self.realmRepository.addTVShowDetails(tvShow: tvShow)
                self.bannerOfflineShowID = tvShow.id
            }
            self.tvShowsDelegate?.onBannerLoaded()
        }
    }
    
    func getTVShowRealm(id: Int?) -> Bool {
        guard let tvShowRealm = self.realmRepository.getTVShow(id: id) else {
            return false
        }
        self.tvShow = TVShow(tvShow: tvShowRealm)
        self.tvShowsDelegate?.onBannerLoaded()
        return true
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
    
    func getOnTheAirTVShow(at index: Int) -> TVShow {
        return self.onTheAirList[index]
    }
    
    func getPopularTVShow(at index: Int) -> TVShow {
        return self.popularList[index]
    }
    
    func getCast(at index: Int) -> Cast? {
        return self.cast?[index]
    }
}
