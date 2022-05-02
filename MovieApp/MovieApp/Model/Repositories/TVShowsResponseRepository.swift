//
//  TVShowsResponseRepository.swift
//  MovieApp
//
//  Created by Julio Gabriel Tobares on 02/05/2022.
//

import Foundation

class TVShowsResponseRepository {
    
    // MARK: - Constants
    let responseApiService: BaseAPIService<TVShowsResponse>
    let baseUrl = Bundle.main.object(forInfoDictionaryKey: Constants.Api.baseUrlBundle) as? String ?? ""
    let apiKey = Bundle.main.object(forInfoDictionaryKey: Constants.Api.apiKeyBundle) as? String ?? ""
    
    
    // MARK: - Initializers
    init() {
        self.responseApiService = BaseAPIService(baseUrl: baseUrl)
    }
    
    init(apiService: BaseAPIService<TVShowsResponse>) {
        self.responseApiService = apiService
    }
    
    // MARK: - Functions
    func getListOfTVSHows(page: Int? = nil, category: TVShowsCategory, completion: @escaping (Result<TVShowsResponse, CustomError>) -> Void) {
        var endpoint = Constants.Api.tvShowEndpoint + "/"
        switch category {
        case .onTheAir:
            endpoint += Constants.Api.onTheAir
        case .popular:
            endpoint += Constants.Api.popular
        }
        let queryParams: [String: String] = [
            Constants.Api.regionQueryKey: Constants.Api.regionQueryParamUS,
            Constants.Api.pageQueryKey: "\(page ?? 1)",
            Constants.Api.apiKeyQueryKey: self.apiKey
        ]
        self.responseApiService.get(endpoint: endpoint, queryParams: queryParams, completion: completion)
    }
}
