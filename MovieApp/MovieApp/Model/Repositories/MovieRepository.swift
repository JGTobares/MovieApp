//
//  MovieRepository.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 27/04/22.
//

import Foundation

class MovieRepository {
    
    // MARK: - Constants
    let apiService: BaseAPIService<Movie>
    let omdbService: BaseAPIService<MovieOMDB>
    let baseUrl = Bundle.main.object(forInfoDictionaryKey: Constants.Api.baseUrlBundle) as? String ?? ""
    let apiKey = Bundle.main.object(forInfoDictionaryKey: Constants.Api.apiKeyBundle) as? String ?? ""
    let omdbBaseUrl = Bundle.main.object(forInfoDictionaryKey: Constants.Api.baseUrlBundle) as? String ?? ""
    let omdbApiKey = Bundle.main.object(forInfoDictionaryKey: Constants.Api.apiKeyBundle) as? String ?? ""
    
    // MARK: - Initializers
    init() {
        self.apiService = BaseAPIService(baseUrl: baseUrl)
        self.omdbService = BaseAPIService(baseUrl: omdbBaseUrl)
    }
    
    init(apiService: BaseAPIService<Movie>) {
        self.apiService = apiService
        self.omdbService = BaseAPIService(baseUrl: omdbBaseUrl)
    }
    
    // MARK: - Functions
    func getMovieDetails(id: Int?, completion: @escaping (Result<Movie, CustomError>) -> Void) {
        guard let id = id else {
            completion(.failure(.internalError))
            return
        }
        let endpoint = "\(Constants.Api.movieEndpoint)/\(id)"
        let queryParams: [String: String] = [
            Constants.Api.appendQueryKey: Constants.Api.appendQueryParams,
            Constants.Api.apiKeyQueryKey: self.apiKey
        ]
        self.apiService.get(endpoint: endpoint, queryParams: queryParams, completion: completion)
    }
    
    func getMovieRating(id: String?, completion: @escaping (Result<MovieOMDB, CustomError>) -> Void) {
        guard let id = id else {
            completion(.failure(.notFoundError))
            return
        }
        let queryParams: [String: String] = [
            Constants.Api.imdbIdQueryKey: id,
            Constants.Api.omdbApiKeyQueryKey: self.omdbApiKey
        ]
        self.omdbService.get(endpoint: "", queryParams: queryParams, completion: completion)
    }
}
