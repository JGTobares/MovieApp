//
//  APIService.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 13/04/22.
//

import Foundation

class APIService: APIServiceProtocol {
    
    // MARK: Constants
    static let shared = APIService()
    
    let baseUrl = Bundle.main.object(forInfoDictionaryKey: Constants.Api.baseUrlBundle)!
    let apiKey = Bundle.main.object(forInfoDictionaryKey: Constants.Api.apiKeyBundle)!
    
    // MARK: Functions
    func getMovieDetails(id: Int?, completion: @escaping (Result<Movie, CustomError>) -> Void) {
        guard let id = id else {
            return
        }
        let urlString = "\(self.baseUrl)movie/\(id)?api_key=\(apiKey)&append_to_response=credits,videos"
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlError))
            return
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
            guard let json = data else {
                completion(.failure(.connectionError))
                return
            }
            do {
                let movie = try JSONDecoder().decode(Movie.self, from: json)
                completion(.success(movie))
            } catch {
                completion(.failure(.jsonError))
            }
        }.resume()
    }
    
    func getMoviesNowPlaying(completion: @escaping (Result<[Movie], CustomError>) -> Void) {
        self.getListOfMovies(endpoint: Constants.Api.nowEndpoint) { result in
            switch(result) {
            case .success(let movies):
                completion(.success(movies))
                break
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getMoviesUpcoming(completion: @escaping (Result<[Movie], CustomError>) -> Void) {
        self.getListOfMovies(endpoint: Constants.Api.upcomingEndpoint) { result in
            switch(result) {
            case .success(let movies):
                completion(.success(movies))
                break
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getMoviesPopular(completion: @escaping (Result<[Movie], CustomError>) -> Void) {
        self.getListOfMovies(endpoint: Constants.Api.popularEndpoint) { result in
            switch(result) {
            case .success(let movies):
                completion(.success(movies))
                break
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getListOfMovies(endpoint: String, completion: @escaping (Result<[Movie], CustomError>) -> Void) {
        self.getListOfMovies(page: nil, endpoint: endpoint, completion: completion)
    }
    
    func getMoviesNowPlaying(page: Int?, completion: @escaping (Result<[Movie], CustomError>) -> Void) {
        self.getListOfMovies(page: page, endpoint: Constants.Api.nowEndpoint) { result in
            switch(result) {
            case .success(let movies):
                completion(.success(movies))
                break
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getMoviesUpcoming(page: Int?, completion: @escaping (Result<[Movie], CustomError>) -> Void) {
        self.getListOfMovies(page: page, endpoint: Constants.Api.upcomingEndpoint) { result in
            switch(result) {
            case .success(let movies):
                completion(.success(movies))
                break
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getMoviesPopular(page: Int?, completion: @escaping (Result<[Movie], CustomError>) -> Void) {
        self.getListOfMovies(page: page, endpoint: Constants.Api.popularEndpoint) { result in
            switch(result) {
            case .success(let movies):
                completion(.success(movies))
                break
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getListOfMovies(page: Int?, endpoint: String, completion: @escaping (Result<[Movie], CustomError>) -> Void) {
        let page = page ?? 1
        let urlString = "\(self.baseUrl)movie/\(endpoint)?api_key=\(apiKey)&region=US&page=\(page)"
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlError))
            return
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
                let json = try JSONDecoder().decode(MoviesResponse.self, from: safeData)
                guard let movies = json.results else {
                    completion(.failure(.jsonError))
                    return
                }
                completion(.success(movies))
            } catch {
                completion(.failure(.jsonError))
            }
        }.resume()
    }
    
    func getMoviesResponse(category: MoviesCategory?, completion: @escaping (Result<MoviesResponse, CustomError>) -> Void) {
        let endpoint: String
        switch category {
        case .now:
            endpoint = Constants.Api.nowEndpoint
        case .popular:
            endpoint = Constants.Api.popularEndpoint
        case .upcoming:
            endpoint = Constants.Api.upcomingEndpoint
        default:
            return
        }
        let urlString = "\(self.baseUrl)movie/\(endpoint)?api_key=\(apiKey)&region=US"
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlError))
            return
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
                let moviesResponse = try JSONDecoder().decode(MoviesResponse.self, from: safeData)
                completion(.success(moviesResponse))
            } catch {
                completion(.failure(.jsonError))
            }
        }.resume()
    }
    
    func searchFor(query: String, page: Int?, completion: @escaping (Result<MoviesResponse, CustomError>) -> Void) {
        let urlString = "\(self.baseUrl)search/movie?api_key=\(apiKey)&region=US&query=\(query)&page=\(page ?? 1)"
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlError))
            return
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
                let moviesResponse = try JSONDecoder().decode(MoviesResponse.self, from: safeData)
                completion(.success(moviesResponse))
            } catch {
                completion(.failure(.jsonError))
            }
        }.resume()
    }
}
