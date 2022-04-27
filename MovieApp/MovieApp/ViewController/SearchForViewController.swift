//
//  SearchForViewController.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 25/04/22.
//

import UIKit

class SearchForViewController: SearchResultsViewController {
    
    // MARK: - Variables
    var input: String?
    
    
    // MARK: - Initializers
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = String(format: Constants.SearchFor.searchedForTitle, input?.removingPercentEncoding ?? "")
        self.manager.searchFor(query: input ?? "")
    }
    
    // MARK: - Actions
    override func onNextPressed() {
        super.onNextPressed()
        self.manager.searchFor(query: input ?? "")
    }
    
    override func onPreviousPressed() {
        super.onPreviousPressed()
        self.manager.searchFor(query: input ?? "")
    }
    
}
