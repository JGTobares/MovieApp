//
//  ViewController.swift
//  MovieApp
//
//  Created by Julio Gabriel Tobares on 12/04/2022.
//

import UIKit
import SideMenu

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
    @IBOutlet var nowSeeAllButton: UIButton!
    @IBOutlet var popularSeeAllButton: UIButton!
    @IBOutlet var upcomingSeeAllButton: UIButton!
    @IBOutlet weak var searchButtonIcon: UIButton!

    // MARK: - Constants
    let movieManager = StorageManager()
    
    // MARK: - Variables
    var menu: SideMenuNavigationController?
    
    // MARK: - Constructors
    override func viewDidLoad() {
        super.viewDidLoad()
        movieManager.networkStatus()
        self.configureObservers()
        movieManager.setMoviesDelegate(self)
        self.configureButtons()
        self.configureCollections()
    }

    // MARK: - Functions
    func configureObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(checkNetworkStatus(notification:)), name: Notification.Name(Constants.Network.updateNetworkStatus), object: nil)
    }
    
    @objc func checkNetworkStatus(notification: NSNotification) {
        let statusNetwork = notification.userInfo?[Constants.Network.updateNetworkStatus] as? String
            if statusNetwork == Constants.Network.statusOnline {
                movieManager.getMovies()
            } else {
                //GET DATA FROM REALM
                CustomToast.show(message: Constants.Network.toastOfflineStatus, bgColor: .red, textColor: .white, labelFont: .boldSystemFont(ofSize: 16), showIn: .bottom, controller: self)
            }
    }
    
    func configureCollections() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: Constants.Cell.width, height: Constants.Cell.height)
        layout.scrollDirection = .horizontal
        
        nowMovies.collectionViewLayout = layout
        nowMovies.register(CustomCollectionViewCell.nib(), forCellWithReuseIdentifier: Constants.Cell.collectionCell)
        nowMovies.delegate = self
        nowMovies.dataSource = self
        
        popularMovies.collectionViewLayout = layout
        popularMovies.register(CustomCollectionViewCell.nib(), forCellWithReuseIdentifier: Constants.Cell.collectionCell)
        popularMovies.delegate = self
        popularMovies.dataSource = self
        
        upcomingMovies.collectionViewLayout = layout
        upcomingMovies.register(CustomCollectionViewCell.nib(), forCellWithReuseIdentifier: Constants.Cell.collectionCell)
        upcomingMovies.delegate = self
        upcomingMovies.dataSource = self
    }
    
    func configureButtons() {
        self.searchButtonIcon.addTarget(self, action: #selector(self.onSearchPressed), for: .touchUpInside)
        
        self.nowSeeAllButton.addAction(UIAction(handler: { [weak self] action in
            self?.onSeeAllPressed(category: .now)
        }), for: .touchUpInside)
        self.popularSeeAllButton.addAction(UIAction(handler: { [weak self] action in
            self?.onSeeAllPressed(category: .popular)
        }), for: .touchUpInside)
        self.upcomingSeeAllButton.addAction(UIAction(handler: { [weak self] action in
            self?.onSeeAllPressed(category: .upcoming)
        }), for: .touchUpInside)
    }
    
    func refreshMovies() {
        DispatchQueue.main.async { [weak self] in
            self?.nowMovies.reloadData()
            self?.popularMovies.reloadData()
            self?.upcomingMovies.reloadData()
            self?.refreshBanner()
        }
    }
    
    func refreshBanner() {
        guard let movie: Movie = movieManager.movieBanner else {
            self.bannerPoster.setImage(imageurl: nil)
            self.bannerBackground.setBackground(imageurl: nil)
            self.bannerTitle.text = ""
            self.bannerCategory.text = ""
            self.bannerRating.isHidden = true
            self.bannerDescription.text = ""
            self.bannerDetails.isHidden = true
            return
        }
        self.bannerPoster.setImage(imageurl: movie.posterPath)
        self.bannerBackground.setBackground(imageurl: movie.backdropPath)
        self.bannerTitle.text = movie.title
        self.bannerCategory.text = movie.releaseDate
        self.bannerRating.isHidden = true
        self.bannerDescription.text = movie.overview
    }
    
    // MARK: - Actions
    @IBAction func btnViewDetail(_ sender: Any) {
        guard let movie: Movie = movieManager.movieBanner else {
            return
        }
        let vc = MovieDetailsViewController()
        vc.movieID = movie.id
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func onSeeAllPressed(category: MoviesCategory) {
        let vc = SeeAllViewController(nibName: Constants.Nib.searchResults, bundle: nil)
        vc.category = category
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
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
            let vc = SearchForViewController(nibName: Constants.Nib.searchResults, bundle: nil)
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

// MARK: - Extensions
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
            let cell = nowMovies.dequeueReusableCell(withReuseIdentifier: Constants.Cell.collectionCell, for: indexPath) as! CustomCollectionViewCell
            let movie = movieManager.getNowMovie(at: indexPath.row)
            cell.card = movie
            return cell
        } else if collectionView == self.popularMovies {
            let cell = popularMovies.dequeueReusableCell(withReuseIdentifier: Constants.Cell.collectionCell, for: indexPath) as! CustomCollectionViewCell
            let movie = movieManager.getPopularMovie(at: indexPath.row)
            cell.card = movie
            return cell
        } else {
            let cell = upcomingMovies.dequeueReusableCell(withReuseIdentifier: Constants.Cell.collectionCell, for: indexPath) as! CustomCollectionViewCell
            let movie = movieManager.getUpcomingMovie(at: indexPath.row)
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
