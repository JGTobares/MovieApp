//
//  DetailsViewController.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 29/04/22.
//

import UIKit

class MovieDetailsViewController: DetailsViewController {

    // MARK: - Constants
    let favoritesManager = FavoritesManager()
    
    
    // MARK: - Variables
    var movieID: Int?
    
    
    // MARK: - Initializers
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.movieDetailsVCDelegate = self
        manager.getDetails(movieID: self.movieID)
        
        // Check if Movie is in Favorites
        self.heartButton.tintColor = .lightGray
        if favoritesManager.isMovieFavorite(id: self.movieID) {
            self.heartButton.tintColor = .red
        }
    }
    
    // MARK: - Functions
    override func didTapHeart(_ sender: Any) {
        super.didTapHeart(sender)
        favoritesManager.updateFavoriteStatus(id: self.movieID, isFavorite: (self.heartButton.tintColor == .red))
    }
}

// MARK: - Extensions
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
                self.movieDirectorLabel.text = String.localizedStringWithFormat(Constants.Details.directorLabel, director)
            }
            self.movieDateLabel.text = String.localizedStringWithFormat(Constants.Details.releaseDateLabel, movie.getFormattedReleaseDate())
            self.movieRuntimeLabel.text = String.localizedStringWithFormat(Constants.Details.runtimeLabel, movie.getRuntimeString())
            self.movieOverviewLabel.text = movie.overview ?? ""
            self.movieStatusLabel.text = String.localizedStringWithFormat(Constants.Details.statusLabel, movie.status ?? Constants.Details.statusUnknown)
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
