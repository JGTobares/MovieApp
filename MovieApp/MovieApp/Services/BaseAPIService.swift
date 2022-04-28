//
//  BaseAPIService.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 27/04/22.
//

import Foundation

class BaseAPIService<ApiModel: Codable> {
    
    // MARK: - Constants
    let baseUrl: String
    let apiKey: String
    
    // MARK: - Initializers
    init(baseUrl: String) {
        self.baseUrl = baseUrl
        self.apiKey = Bundle.main.object(forInfoDictionaryKey: Constants.Api.apiKeyBundle) as? String ?? ""
    }
    
    // MARK: - GET
    func get(endpoint: String, queryParams: [String: String], completion: @escaping (Result<ApiModel, CustomError>) -> Void) {
        let urlString = "\(self.baseUrl)\(endpoint)?api_key=\(self.apiKey)"
        guard var url = URL(string: urlString) else {
            completion(.failure(.urlError))
            return
        }
        queryParams.forEach { queryParam in
            url.appendQueryItem(name: queryParam.key, value: queryParam.value)
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                completion(.failure(.connectionError))
                return
            }
            guard let safeResponse = response as? HTTPURLResponse else {
                completion(.failure(.connectionError))
                return
            }
            if safeResponse.statusCode != 200 {
                if safeResponse.statusCode == 401 {
                    completion(.failure(.authorizationError))
                } else {
                    completion(.failure(.notFoundError))
                }
                return
            }
            guard let safeData = data else {
                completion(.failure(.connectionError))
                return
            }
            do {
                let apiResponse = try JSONDecoder().decode(ApiModel.self, from: safeData)
                completion(.success(apiResponse))
            } catch {
                completion(.failure(.jsonError))
            }
        }.resume()
    }
    
    func get(endpoint: String, queryParams: [String: String], completion: @escaping (Result<[ApiModel], CustomError>) -> Void) {
        let urlString = "\(self.baseUrl)\(endpoint)?api_key=\(self.apiKey)"
        guard var url = URL(string: urlString) else {
            completion(.failure(.urlError))
            return
        }
        queryParams.forEach { queryParam in
            url.appendQueryItem(name: queryParam.key, value: queryParam.value)
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                completion(.failure(.connectionError))
                return
            }
            guard let safeResponse = response as? HTTPURLResponse else {
                completion(.failure(.connectionError))
                return
            }
            if safeResponse.statusCode != 200 {
                if safeResponse.statusCode == 401 {
                    completion(.failure(.authorizationError))
                } else {
                    completion(.failure(.notFoundError))
                }
                return
            }
            guard let safeData = data else {
                completion(.failure(.connectionError))
                return
            }
            do {
                let apiResponse = try JSONDecoder().decode([ApiModel].self, from: safeData)
                completion(.success(apiResponse))
            } catch {
                completion(.failure(.jsonError))
            }
        }.resume()
    }
}
