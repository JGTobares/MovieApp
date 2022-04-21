//
//  SearchResultsViewController.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 15/04/22.
//

import UIKit

class SearchResultsViewController: UIViewController {

    // MARK: - Constants
    let manager = SearchResultsManager()
    
    // MARK: - Variables
    var input: String?
    var category: MoviesCategory?
    
    // MARK: - Outlets
    @IBOutlet weak var collectionMovies: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageLabel: UILabel!
    
    // MARK: - Constructors
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: Constants.Cell.width, height: Constants.Cell.height)
        layout.scrollDirection = .vertical
        collectionMovies.collectionViewLayout = layout
        collectionMovies.register(CustomCollectionViewCell.nib(), forCellWithReuseIdentifier: Constants.Cell.collectionCell)
        collectionMovies.delegate = self
        collectionMovies.dataSource = self
        
        self.manager.delegate = self
        self.manager.getMovieResponse(category: self.category)
        
        self.titleLabel.text = self.manager.getTitleLabel(category: self.category)
        
        self.nextButton.addTarget(self, action: #selector(onNextPressed), for: .touchUpInside)
        self.previousButton.addTarget(self, action: #selector(onPreviousPressed), for: .touchUpInside)
        
        self.nextButton.isHidden = !self.manager.hasNextPage()
        self.previousButton.isHidden = !self.manager.hasPreviousPage()
    }
    
    // MARK: - Functions
    func refreshMovies() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionMovies.reloadData()
            self?.pageLabel.text = "\(self?.manager.currentPage ?? 0)/\(self?.manager.totalPages ?? 0)"
            self?.nextButton.isHidden = !(self?.manager.hasNextPage() ?? true)
            self?.previousButton.isHidden = !(self?.manager.hasPreviousPage() ?? true)
        }
    }
    
    // MARK: - Actions
    @IBAction func onBackPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @objc func onNextPressed() {
        if !self.manager.hasNextPage() {
            return
        }
        self.manager.nextPage()
        self.manager.loadMoviesFromCategory(self.category)
    }
    
    @objc func onPreviousPressed() {
        if !self.manager.hasPreviousPage() {
            return
        }
        self.manager.previousPage()
        self.manager.loadMoviesFromCategory(self.category)
    }
}

// MARK: - Extensions
extension SearchResultsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = MovieDetailsViewController()
        guard let movie = manager.movies?[indexPath.row], let movieID = movie.id else {
            return
        }
        vc.movieID = movieID
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}

extension SearchResultsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.manager.movies?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionMovies.dequeueReusableCell(withReuseIdentifier: Constants.Cell.collectionCell, for: indexPath) as? CustomCollectionViewCell, let movie = manager.movies?[indexPath.row] else {
            return UICollectionViewCell()
        }
        cell.card = movie
        return cell
    }
}

extension SearchResultsViewController: SearchResultsManagerDelegate {
    
    func onSeeAllLoaded() {
        self.refreshMovies()
    }
}
