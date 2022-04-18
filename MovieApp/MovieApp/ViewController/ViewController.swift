//
//  ViewController.swift
//  MovieApp
//
//  Created by Julio Gabriel Tobares on 12/04/2022.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet var bannerBackground: UIImageView!
    @IBOutlet var bannerPoster: UIImageView!
    @IBOutlet var bannerTitle: UILabel!
    @IBOutlet var bannerCategory: UILabel!
    @IBOutlet var bannerRating: UILabel!
    @IBOutlet var bannerDescription: UILabel!
    @IBOutlet var bannerDetails: UIButton!
    @IBOutlet var nowMovies: UICollectionView!
    @IBOutlet var popularMovies: UICollectionView!
    @IBOutlet var upcomingMovies: UICollectionView!
    @IBOutlet var searchButton: UIBarButtonItem!
    @IBOutlet var nowSeeAllButton: UIButton!
    @IBOutlet var popularSeeAllButton: UIButton!
    @IBOutlet var upcomingSeeAllButton: UIButton!
    @IBOutlet weak var searchButtonIcon: UIButton!

    // MARK: - Constants
    let movieManager: MovieManager = MovieManager()
    
    // MARK: - Constructors
    override func viewDidLoad() {
        super.viewDidLoad()
        movieManager.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 230)
        layout.scrollDirection = .horizontal
        
        nowMovies.collectionViewLayout = layout
        nowMovies.register(CustomCollectionViewCell.nib(), forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        nowMovies.delegate = self
        nowMovies.dataSource = self
        
        popularMovies.collectionViewLayout = layout
        popularMovies.register(CustomCollectionViewCell.nib(), forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        popularMovies.delegate = self
        popularMovies.dataSource = self
        
        upcomingMovies.collectionViewLayout = layout
        upcomingMovies.register(CustomCollectionViewCell.nib(), forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        upcomingMovies.delegate = self
        upcomingMovies.dataSource = self
        
        movieManager.loadNowMovies()
        movieManager.loadPopularMovies()
        movieManager.loadUpcomingMovies()
        
        self.searchButtonIcon.addTarget(self, action: #selector(self.onSearchPressed), for: .touchUpInside)
    }

    // MARK: - Functions
    func refreshMovies() {
        DispatchQueue.main.async { [weak self] in
            self?.nowMovies.reloadData()
            self?.popularMovies.reloadData()
            self?.upcomingMovies.reloadData()
            self?.refreshBanner()
        }
    }
    
    func refreshBanner() {
        let movie: Movie = movieManager.bannerMovie
        if let posterURL = movie.posterPath, let bkgndURL = movie.backdropPath {
            let bkgndUrl = Constants.MovieDetails.urlBaseBackground + bkgndURL
            let posterUrl = Constants.MovieDetails.urlBasePoster + posterURL
            self.bannerPoster.setImage(imageurl: posterUrl)
            self.bannerBackground.setBackground(imageurl: bkgndUrl)
        } else {
            self.bannerPoster.image = UIImage(named: "emptyImage")!
            self.bannerBackground.image = UIImage(named: "emptyImage")!
        }
        self.bannerTitle.text = movie.title
        self.bannerCategory.text = movie.releaseDate
        self.bannerRating.isHidden = true
        self.bannerDescription.text = movie.overview
    }
    
    // MARK: - Actions
    @IBAction func btnViewDetail(_ sender: Any) {
        let movie: Movie = movieManager.bannerMovie
        let vc = MovieDetailsViewController()
        vc.movieID = movie.id
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func showAlertMessage(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Constants.General.okLabel, style: .cancel, handler: { _ in
                alert.dismiss(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func onSearchPressed() {
        let alert = UIAlertController(title: Constants.SearchFor.dialogTitle, message: Constants.SearchFor.dialogMessage, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = Constants.SearchFor.dialogInput
        })
        alert.addAction(UIAlertAction(title: Constants.SearchFor.dialogTitle, style: .default, handler: { _ in
            guard let textFields = alert.textFields, textFields.count > 0 else {
                alert.dismiss(animated: true)
                self.showAlertMessage(title: Constants.General.internalError, message: Constants.General.alertError)
                return
            }
            let input = textFields[0].text?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            if input.isEmpty {
                alert.dismiss(animated: true)
                self.showAlertMessage(title: Constants.General.validationError, message: Constants.General.inputErrorMessage)
                return
            }
            let vc = SearchResultsViewController()
            vc.input = input
            vc.modalPresentationStyle = .fullScreen
            alert.dismiss(animated: true)
            self.present(vc, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: Constants.General.cancelLabel, style: .cancel, handler: { _ in
            alert.dismiss(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        nowMovies.deselectItem(at: indexPath, animated: true)
        let movie: Movie
        if collectionView == self.nowMovies {
            movie = self.movieManager.getNowMovie(at: indexPath.row)
        } else if collectionView == self.popularMovies {
            movie = self.movieManager.getPopularMovie(at: indexPath.row)
        } else {
            movie = self.movieManager.getUpcomingMovie(at: indexPath.row)
        }
        let vc = MovieDetailsViewController()
        vc.movieID = movie.id
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.nowMovies {
            return movieManager.nowMovieCount
        } else if collectionView == self.popularMovies {
            return movieManager.popularMovieCount
        } else {
            return movieManager.upcomingMovieCount
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.nowMovies {
            let cell = nowMovies.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as! CustomCollectionViewCell
            let movie = movieManager.nowMovies[indexPath.row]
            cell.card = movie
            return cell
        } else if collectionView == self.popularMovies {
            let cell = popularMovies.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as! CustomCollectionViewCell
            let movie = movieManager.popularMovies[indexPath.row]
            cell.card = movie
            return cell
        } else {
            let cell = upcomingMovies.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as! CustomCollectionViewCell
            let movie = movieManager.upcomingMovies[indexPath.row]
            cell.card = movie
            return cell
        }
    }
}

extension ViewController: MovieManagerDelegate {
    
    func onNowLoaded() {
        refreshMovies()
    }
    
    func onPopularLoaded() {
        refreshMovies()
    }
    
    func onUpcomingLoaded() {
        refreshMovies()
    }
}
