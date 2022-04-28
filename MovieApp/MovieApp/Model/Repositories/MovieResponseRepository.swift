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
        var endpoint = "movie/"
        switch category {
        case .now:
            endpoint += Constants.Api.nowEndpoint
        case .popular:
            endpoint += Constants.Api.popularEndpoint
        case .upcoming:
            endpoint += Constants.Api.upcomingEndpoint
        }
        let queryParams: [String: String] = [
            "region": "US",
            "page": "\(page ?? 1)"
        ]
        self.responseApiService.get(endpoint: endpoint, queryParams: queryParams, completion: completion)
    }
    
    func searchFor(query: String, page: Int?, completion: @escaping (Result<MoviesResponse, CustomError>) -> Void) {
        let endpoint = "search/movie"
        let queryParams: [String: String] = [
            "region": "US",
            "query": query,
            "page": "\(page ?? 1)"
        ]
        self.responseApiService.get(endpoint: endpoint, queryParams: queryParams, completion: completion)
    }
}
