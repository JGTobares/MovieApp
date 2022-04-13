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
    
    let urlBase = Bundle.main.object(forInfoDictionaryKey: "urlBase")!
    let apiKey = Bundle.main.object(forInfoDictionaryKey: "apiKey")!
    
    // MARK: Functions
    func getMovieDetails(id: Int?, completion: @escaping (Result<Movie, CustomError>) -> Void) {
        guard let id = id else {
            return
        }
        let urlString = "\(self.urlBase)movie/\(id)?api_key=\(apiKey)"
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
        self.getListOfMovies(endpoint: "now_playing") { result in
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
        self.getListOfMovies(endpoint: "upcoming") { result in
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
        self.getListOfMovies(endpoint: "popular") { result in
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
        let urlString = "\(self.urlBase)movie/\(endpoint)?api_key=\(apiKey)&region=US"
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
    
}
