//
//  SeeAllViewController.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 25/04/22.
//

import UIKit

class SeeAllViewController: SearchResultsViewController {
    
    // MARK: - Variables
    var category: MoviesCategory?
    
    
    // MARK: - Initializers
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = self.manager.getTitleLabel(category: self.category)
        self.manager.getMovieResponse(category: self.category)
    }
    
    // MARK: - Actions
    override func onNextPressed() {
        super.onNextPressed()
        self.manager.loadMoviesFromCategory(self.category)
    }
    
    override func onPreviousPressed() {
        super.onPreviousPressed()
        self.manager.loadMoviesFromCategory(self.category)
    }
}
