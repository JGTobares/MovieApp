//
//  SearchResultsManager.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 18/04/22.
//

import Foundation

class SearchResultsManager {
    
    // MARK: - Constants
    let apiService: APIServiceProtocol
    
    // MARK: - Variables
    var movies: [Movie]? {
        didSet {
            self.delegate?.onSeeAllLoaded()
        }
    }
    var currentPage: Int? = 1
    var totalPages: Int?
    var delegate: SearchResultsManagerDelegate?
    
    // MARK: - Initializers
    init() {
        self.apiService = APIService.shared
    }
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    // MARK: - Functions
    func getTitleLabel(category: MoviesCategory?) -> String {
        let title = Constants.SeeAll.categoryTitle
        switch category {
        case .now:
            return title + Constants.SeeAll.categoryNow
        case .popular:
            return title + Constants.SeeAll.categoryPopular
        case .upcoming:
            return title + Constants.SeeAll.categoryUpcoming
        default:
            return ""
        }
    }
    
    func setTotalPages(total: Int?) {
        guard let total = total else {
            return
        }
        self.totalPages = total < Constants.Api.maxTotalPages ? total : Constants.Api.maxTotalPages
    }
    
    func getMovieResponse(category: MoviesCategory?) {
        self.apiService.getMoviesResponse(category: category) { result in
            switch result {
            case .success(let response):
                self.currentPage = response.page
                self.setTotalPages(total: response.totalPages)
                self.movies = response.results ?? []
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func loadMoviesFromCategory(_ category: MoviesCategory?) {
        switch category {
        case .now:
            self.apiService.getMoviesNowPlaying(page: self.currentPage, completion: self.loadResult(_:))
            break
        case .popular:
            self.apiService.getMoviesPopular(page: self.currentPage, completion: self.loadResult(_:))
            break
        case .upcoming:
            self.apiService.getMoviesUpcoming(page: self.currentPage, completion: self.loadResult(_:))
            break
        default:
            break
        }
    }
    
    func loadResult(_ result: Result<[Movie], CustomError>) {
        switch result {
        case .success(let movies):
            self.movies = movies
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    func nextPage() {
        if self.currentPage != nil {
            self.currentPage! += 1
        }
    }
    
    func previousPage() {
        if self.currentPage != nil {
            self.currentPage! -= 1
        }
    }
    
    func hasPreviousPage() -> Bool {
        if let page = self.currentPage, page != 1 {
            return true
        } else {
            return false
        }
    }
    
    func hasNextPage() -> Bool {
        if let page = self.currentPage, let total = self.totalPages, page != total {
            return true
        } else {
            return false
        }
    }
}
