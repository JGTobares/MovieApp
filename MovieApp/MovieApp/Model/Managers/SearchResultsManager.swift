//
//  SearchResultsManager.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 18/04/22.
//

import Foundation

class SearchResultsManager {
    
    // MARK: - Constants
    let repository: MovieResponseRepository
    
    
    // MARK: - Variables
    var movies: [Movie]? {
        didSet {
            self.delegate?.onSeeAllLoaded()
        }
    }
    var currentPage: Int? = 1
    var totalPages: Int?
    var delegate: SearchResultsManagerDelegate?
    var errorDelegate: ErrorAlertDelegate? {
        return self.delegate as? ErrorAlertDelegate
    }
    
    // MARK: - Initializers
    init() {
        self.repository = MovieResponseRepository()
    }
    
    init(baseApiService: BaseAPIService<MoviesResponse>) {
        self.repository = MovieResponseRepository(apiService: baseApiService)
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
        guard let category = category else {
            return
        }
        self.repository.getListOfMovies(page: self.currentPage, category: category) { result in
            switch result {
            case .success(let response):
                self.currentPage = response.page
                self.setTotalPages(total: response.totalPages)
                self.movies = response.results ?? []
                break
            case .failure(let error):
                self.errorDelegate?.showAlertMessage(title: Constants.General.errorTitle, message: error.rawValue)
            }
        }
    }
    
    func searchFor(query: String) {
        self.repository.searchFor(query: query.replacingOccurrences(of: "%20", with: "+"), page: self.currentPage) { result in
            switch result {
            case .success(let response):
                self.currentPage = response.page
                self.setTotalPages(total: response.totalPages)
                self.movies = response.results ?? []
                break
            case .failure(let error):
                self.errorDelegate?.showAlertMessage(title: Constants.General.errorTitle, message: error.rawValue)
            }
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
