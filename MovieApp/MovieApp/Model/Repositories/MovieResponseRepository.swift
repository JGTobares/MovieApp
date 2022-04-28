//
//  MovieResponseRepository.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 27/04/22.
//

import Foundation

class MovieResponseRepository {
    
    // MARK: - Constants
    let responseApiService: BaseAPIService<MoviesResponse>
    
    
    // MARK: - Initializers
    init() {
        let baseUrl = Bundle.main.object(forInfoDictionaryKey: Constants.Api.baseUrlBundle) as? String ?? ""
        responseApiService = BaseAPIService(baseUrl: baseUrl)
    }
    
    init(apiService: BaseAPIService<MoviesResponse>) {
        self.responseApiService = apiService
    }
    
    // MARK: - Functions
    func getListOfMovies(page: Int? = nil, category: MoviesCategory, completion: @escaping (Result<MoviesResponse, CustomError>) -> Void) {
        var endpoint = Constants.Api.movieEndpoint + "/"
        switch category {
        case .now:
            endpoint += Constants.Api.nowEndpoint
        case .popular:
            endpoint += Constants.Api.popularEndpoint
        case .upcoming:
            endpoint += Constants.Api.upcomingEndpoint
        }
        let queryParams: [String: String] = [
            Constants.Api.regionQueryKey: Constants.Api.regionQueryParamUS,
            Constants.Api.pageQueryKey: "\(page ?? 1)"
        ]
        self.responseApiService.get(endpoint: endpoint, queryParams: queryParams, completion: completion)
    }
    
    func searchFor(query: String, page: Int?, completion: @escaping (Result<MoviesResponse, CustomError>) -> Void) {
        let endpoint = Constants.Api.searchMovieEndpoint
        let queryParams: [String: String] = [
            Constants.Api.regionQueryKey: Constants.Api.regionQueryParamUS,
            Constants.Api.queryQueryKey: query,
            Constants.Api.pageQueryKey: "\(page ?? 1)"
        ]
        self.responseApiService.get(endpoint: endpoint, queryParams: queryParams, completion: completion)
    }
}
