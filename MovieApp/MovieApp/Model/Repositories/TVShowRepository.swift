//
//  TVShowRepository.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 29/04/22.
//

import Foundation

class TVShowRepository {
    
    // MARK: - Constants
    let apiService: BaseAPIService<TVShow>
    let baseUrl = Bundle.main.object(forInfoDictionaryKey: Constants.Api.baseUrlBundle) as? String ?? ""
    let apiKey = Bundle.main.object(forInfoDictionaryKey: Constants.Api.apiKeyBundle) as? String ?? ""
    
    // MARK: - Initializers
    init() {
        self.apiService = BaseAPIService(baseUrl: baseUrl)
    }
    
    init(apiService: BaseAPIService<TVShow>) {
        self.apiService = apiService
    }
    
    // MARK: - Functions
    func getTVShowDetails(id: Int?, completion: @escaping (Result<TVShow, CustomError>) -> Void) {
        guard let id = id else {
            completion(.failure(.internalError))
            return
        }
        let endpoint = "\(Constants.Api.tvShowEndpoint)/\(id)"
        let queryParams: [String: String] = [
            Constants.Api.appendQueryKey: Constants.Api.appendQueryParams,
            Constants.Api.apiKeyQueryKey: self.apiKey
        ]
        self.apiService.get(endpoint: endpoint, queryParams: queryParams, completion: completion)
    }
}
