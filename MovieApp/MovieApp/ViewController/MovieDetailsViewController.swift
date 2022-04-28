//
//  MovieDetailsViewController.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 14/04/22.
//

import UIKit
import youtube_ios_player_helper

class MovieDetailsViewController: UIViewController {
    
    // MARK: - Constants
    let manager = StorageManager()
    
    
    // MARK: - Variables
    var movieID: Int?
    var tabShown: Int?
    
    // MARK: - Outlets
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieTaglineLabel: UILabel!
    @IBOutlet weak var movieGenresLabel: UILabel!
    @IBOutlet weak var movieDirectorLabel: UILabel!
    @IBOutlet weak var movieDateLabel: UILabel!
    @IBOutlet weak var movieRuntimeLabel: UILabel!
    @IBOutlet weak var movieOverviewLabel: UILabel!
    @IBOutlet weak var movieWebpageLabel: UILabel!
    @IBOutlet weak var movieStatusLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var castButton: UIButton!
    @IBOutlet weak var trailerButton: UIButton!
    @IBOutlet weak var infoContainer: UIView!
    @IBOutlet weak var castContainer: UIView!
    @IBOutlet weak var trailerContainer: UIView!
    @IBOutlet weak var tabsContainer: UIStackView!
    @IBOutlet var heartButton: UIButton!
    @IBOutlet weak var trailerPlayer: YTPlayerView!
    @IBOutlet weak var trailerErrorLabel: UILabel!
    @IBOutlet weak var castCollectionView: UICollectionView!
    @IBOutlet weak var ratingIcon: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    
    // MARK: - Constructors
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.networkStatus()
        self.configureButtons()
        self.configureObservers()
        manager.setDetailsDelegate(self)
        manager.setErrorDelegate(self)
        self.trailerPlayer.delegate = self
        castCollectionView.register(CustomCollectionViewCell.nib(), forCellWithReuseIdentifier: Constants.Cell.collectionCell)
        castCollectionView.dataSource = self
    }
    
    // MARK: - Functions
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        // Adjust bottom border when device is rotated
        switch self.tabShown {
        case Constants.MovieDetails.infoTabTag:
            self.infoButton.subviews.first(where: { $0.tag == Constants.MovieDetails.infoTabTag })?.removeFromSuperview()
            self.addBottomBorder(view: self.infoButton, tag: Constants.MovieDetails.infoTabTag, width: size.width / 3)
            break
        case Constants.MovieDetails.castTabTag:
            self.castButton.subviews.first(where: { $0.tag == Constants.MovieDetails.castTabTag })?.removeFromSuperview()
            self.addBottomBorder(view: self.castButton, tag: Constants.MovieDetails.castTabTag, width: size.width / 3)
            break
        case Constants.MovieDetails.trailerTabTag:
            self.trailerButton.subviews.first(where: { $0.tag == Constants.MovieDetails.trailerTabTag })?.removeFromSuperview()
            self.addBottomBorder(view: self.trailerButton, tag: Constants.MovieDetails.trailerTabTag, width: size.width / 3)
            break
        default:
            break
        }
    }
    
    func configureObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(checkNetworkStatus(notification: )), name: Notification.Name(Constants.Network.updateNetworkStatus), object: nil)
    }
    
    @objc func checkNetworkStatus(notification: NSNotification) {
        let statusNetwork = notification.userInfo?[Constants.Network.updateNetworkStatus] as? String
        if statusNetwork == Constants.Network.statusOnline {
            manager.getMovieDetails(id: self.movieID)
        } else {
            if !manager.getMovieDetailsRealm(id: self.movieID) {
                CustomToast.show(message: Constants.Network.toastOfflineStatus, bgColor: .red, textColor: .white, labelFont: .boldSystemFont(ofSize: 16), showIn: .bottom, controller: self)
            }
            self.trailerPlayer.isHidden = true
            self.trailerErrorLabel.text = Constants.MovieDetails.trailerErrorMessage
        }
    }
    
    func configureButtons() {
        self.backButton.setTitle("", for: .normal)
        self.backButton.addTarget(self, action: #selector(onBackPressed), for: .touchUpInside)
        self.infoButton.addTarget(self, action: #selector(onInfoPressed), for: .touchUpInside)
        self.castButton.addTarget(self, action: #selector(onCastPressed), for: .touchUpInside)
        self.trailerButton.addTarget(self, action: #selector(onTrailerPressed), for: .touchUpInside)
        self.heartButton.isHidden = true
        
        // Show Info Tab first
        self.infoContainer.isHidden = false
        self.castContainer.isHidden = true
        self.trailerContainer.isHidden = true
        
        // Add red bottom border to selected button
        self.addBottomBorder(view: self.infoButton, tag: Constants.MovieDetails.infoTabTag, width: UIScreen.main.bounds.width / 3)
        self.tabShown = Constants.MovieDetails.infoTabTag
        
        // Check if Movie is in Favorites
        self.heartButton.tintColor = .lightGray
        if manager.isMovieFavorite(movieId: self.movieID) {
            self.heartButton.tintColor = .red
        }
    }
    
    func addBottomBorder(view: UIView, tag: Int, width: CGFloat? = nil) {
        let width = width ?? view.frame.size.width
        let lineView = UIView(frame: CGRect(x: 0, y: view.frame.size.height - 2, width: width, height: 2))
        lineView.backgroundColor = .red
        lineView.tag = tag
        view.addSubview(lineView)
    }
    
    @objc func onBackPressed() {
        self.dismiss(animated: true)
    }
    
    @objc func onInfoPressed() {
        if self.tabShown == Constants.MovieDetails.infoTabTag {
            return
        }
        self.infoContainer.isHidden = false
        self.castContainer.isHidden = true
        self.trailerContainer.isHidden = true
        self.addBottomBorder(view: self.infoButton, tag: Constants.MovieDetails.infoTabTag)
        self.castButton.subviews.first(where: { $0.tag == Constants.MovieDetails.castTabTag })?.removeFromSuperview()
        self.trailerButton.subviews.first(where: { $0.tag == Constants.MovieDetails.trailerTabTag })?.removeFromSuperview()
        self.tabShown = Constants.MovieDetails.infoTabTag
    }
    
    @objc func onCastPressed() {
        if self.tabShown == Constants.MovieDetails.castTabTag {
            return
        }
        self.infoContainer.isHidden = true
        self.castContainer.isHidden = false
        self.trailerContainer.isHidden = true
        self.addBottomBorder(view: self.castButton, tag: Constants.MovieDetails.castTabTag)
        self.infoButton.subviews.first(where: { $0.tag == Constants.MovieDetails.infoTabTag })?.removeFromSuperview()
        self.trailerButton.subviews.first(where: { $0.tag == Constants.MovieDetails.trailerTabTag })?.removeFromSuperview()
        self.tabShown = Constants.MovieDetails.castTabTag
    }
    
    @objc func onTrailerPressed() {
        if self.tabShown == Constants.MovieDetails.trailerTabTag {
            return
        }
        self.infoContainer.isHidden = true
        self.castContainer.isHidden = true
        self.trailerContainer.isHidden = false
        self.addBottomBorder(view: self.trailerButton, tag: Constants.MovieDetails.trailerTabTag)
        self.castButton.subviews.first(where: { $0.tag == Constants.MovieDetails.castTabTag })?.removeFromSuperview()
        self.infoButton.subviews.first(where: { $0.tag == Constants.MovieDetails.infoTabTag })?.removeFromSuperview()
        self.tabShown = Constants.MovieDetails.trailerTabTag
    }
    
    //MARK: - Outlets
    
    @IBAction func didTapHeart(_ sender: Any) {
        if (self.heartButton.tintColor == .lightGray) {
            manager.updateFavoriteStatus(movieId: self.movieID, isFavorite: true)
            self.heartButton.tintColor = .red
        } else {
            manager.updateFavoriteStatus(movieId: self.movieID, isFavorite: false)
            self.heartButton.tintColor = .lightGray
        }
    }
}

// MARK: - Extensions
extension MovieDetailsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.manager.castCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.castCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cell.collectionCell, for: indexPath) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setCast(self.manager.getMovieCast(at: indexPath.row))
        return cell
    }
}

extension MovieDetailsViewController: MovieDetailsViewControllerDelegate {
    
    func didSetMovie(_ movie: Movie) {
        DispatchQueue.main.async {
            self.heartButton.isHidden = false
            self.backgroundImageView.setBackground(imageurl: movie.backdropPath)
            self.posterImageView.setImage(imageurl: movie.posterPath)
            self.movieTitleLabel.text = movie.title ?? ""
            self.movieTaglineLabel.text = movie.tagline ?? ""
            self.movieGenresLabel.text = movie.getGenres()
            let director = movie.getDirector()
            if director.isEmpty {
                self.movieDirectorLabel.text = ""
            } else {
                self.movieDirectorLabel.text = String.localizedStringWithFormat(Constants.MovieDetails.directorLabel, director)
            }
            self.movieDateLabel.text = String.localizedStringWithFormat(Constants.MovieDetails.releaseDateLabel, movie.getFormattedReleaseDate())
            self.movieRuntimeLabel.text = String.localizedStringWithFormat(Constants.MovieDetails.runtimeLabel, movie.getRuntimeString())
            self.movieOverviewLabel.text = movie.overview ?? ""
            self.movieStatusLabel.text = String.localizedStringWithFormat(Constants.MovieDetails.statusLabel, movie.status ?? Constants.MovieDetails.statusUnknown)
            // Make text italics and underlined
            self.movieWebpageLabel.attributedText = NSAttributedString(string: movie.homepage ?? "", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
            self.movieWebpageLabel.font = UIFont.italicSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize)
            // Load YouTube trailer
            self.trailerPlayer.load(withVideoId: movie.getYouTubeTrailer()?.key ?? "")
            // Show rating
            if let rating = movie.rating, rating > 0 {
                self.ratingIcon.isHidden = false
                self.ratingLabel.text = "\(rating)"
            }
        }
    }
    
    func didSetCast(_ cast: [Cast]) {
        DispatchQueue.main.async {
            self.castCollectionView.reloadData()
        }
    }
    
    func didSetRating(_ rating: Double) {
        DispatchQueue.main.async {
            self.ratingIcon.isHidden = false
            self.ratingLabel.text = "\(rating)"
        }
    }
}

extension MovieDetailsViewController: YTPlayerViewDelegate {
    
    func playerViewPreferredWebViewBackgroundColor(_ playerView: YTPlayerView) -> UIColor {
        return .black
    }
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        self.trailerPlayer.isHidden = false
        self.trailerErrorLabel.text = ""
    }
    
    func playerView(_ playerView: YTPlayerView, receivedError error: YTPlayerError) {
        self.trailerPlayer.isHidden = true
        self.trailerErrorLabel.text = Constants.MovieDetails.trailerErrorMessage
    }
}
