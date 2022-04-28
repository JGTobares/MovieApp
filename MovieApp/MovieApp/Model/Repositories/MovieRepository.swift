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
    
    
    // MARK: - Initializers
    init() {
        let baseUrl = Bundle.main.object(forInfoDictionaryKey: Constants.Api.baseUrlBundle) as? String ?? ""
        apiService = BaseAPIService(baseUrl: baseUrl)
    }
    
    init(apiService: BaseAPIService<Movie>) {
        self.apiService = apiService
    }
    
    // MARK: - Functions
    func getMovieDetails(id: Int?, completion: @escaping (Result<Movie, CustomError>) -> Void) {
        guard let id = id else {
            completion(.failure(.internalError))
            return
        }
        let endpoint = "\(Constants.Api.movieEndpoint)/\(id)"
        let queryParams: [String: String] = [
            Constants.Api.appendQueryKey: Constants.Api.appendQueryParams
        ]
        self.apiService.get(endpoint: endpoint, queryParams: queryParams, completion: completion)
    }
}
