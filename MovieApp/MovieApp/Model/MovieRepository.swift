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
//    let responseApiService: BaseAPIService<MoviesResponse>
    
    
    // MARK: - Initializers
    init() {
        let baseUrl = Bundle.main.object(forInfoDictionaryKey: Constants.Api.baseUrlBundle) as? String ?? ""
        apiService = BaseAPIService(baseUrl: baseUrl)
//        responseApiService = BaseAPIService(baseUrl: baseUrl)
    }
    
    // MARK: - Functions
    func getMovieDetails(id: Int?, completion: @escaping (Result<Movie, CustomError>) -> Void) {
        guard let id = id else {
            completion(.failure(.internalError))
            return
        }
        let endpoint = "movie/\(id)"
        let queryParams: [String: String] = [
            "append_to_response": "credits,videos"
        ]
        self.apiService.get(endpoint: endpoint, queryParams: queryParams, completion: completion)
    }
    
    func searchFor(query: String, page: Int?, completion: @escaping (Result<MoviesResponse, CustomError>) -> Void) {
        let endpoint = "search/movie"
        let queryParams: [String: String] = [
            "region": "US",
            "query": query,
            "page": "\(page ?? 1)"
        ]
//        self.responseApiService.get(endpoint: endpoint, queryParams: queryParams, completion: completion)
    }
}
