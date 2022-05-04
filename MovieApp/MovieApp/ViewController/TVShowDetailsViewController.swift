//
//  TVShowDetailsViewController.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 29/04/22.
//

import UIKit

class TVShowDetailsViewController: DetailsViewController {
    // MARK: - Constants
    let tvShowManager = TVShowManager()
    let favoritesManager = FavoritesManager()
    
    
    // MARK: - Variables
    var tvShowId: Int?
    
    
    // MARK: - Initializers
    override func viewDidLoad() {
        super.viewDidLoad()
        //tvShowManager.setDetailsDelegate(self)
        tvShowManager.detailsDelegate = self
        tvShowManager.getData(tvShowID: self.tvShowId)
        
        // Check if TV Show is in Favorites
        self.heartButton.tintColor = .lightGray
        if favoritesManager.isTVShowFavorite(id: self.tvShowId) {
            self.heartButton.tintColor = .red
        }
    }
    
    // MARK: - Functions
    override func didTapHeart(_ sender: Any) {
        super.didTapHeart(sender)
        favoritesManager.updateFavoriteStatus(tvShowId: self.tvShowId, isFavorite: self.heartButton.tintColor == .red)
    }
}

// MARK: - Extensions
extension TVShowDetailsViewController: TVShowDetailsViewControllerDelegate {
    
    func didSetTVShow(_ tvShow: TVShow) {
        DispatchQueue.main.async {
            self.heartButton.isHidden = false
            self.backgroundImageView.setBackground(imageurl: tvShow.backdropPath)
            self.posterImageView.setImage(imageurl: tvShow.posterPath)
            self.movieTitleLabel.text = tvShow.title ?? ""
            self.movieTaglineLabel.text = tvShow.tagline ?? ""
            self.movieGenresLabel.text = tvShow.getGenres()
            let director = tvShow.getDirector()
            if director.isEmpty {
                self.movieDirectorLabel.text = ""
            } else {
                self.movieDirectorLabel.text = String.localizedStringWithFormat(Constants.Details.directorLabel, director)
            }
            self.movieDateLabel.text = String.localizedStringWithFormat(Constants.Details.releaseDateLabel, tvShow.getFormattedReleaseDate())
            self.movieRuntimeLabel.text = String.localizedStringWithFormat(Constants.Details.seasonsLabel, tvShow.runtime ?? 0)
            self.movieOverviewLabel.text = tvShow.overview ?? ""
            self.movieStatusLabel.text = String.localizedStringWithFormat(Constants.Details.statusLabel, tvShow.status ?? Constants.Details.statusUnknown)
            // Make text italics and underlined
            self.movieWebpageLabel.attributedText = NSAttributedString(string: tvShow.homepage ?? "", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
            self.movieWebpageLabel.font = UIFont.italicSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize)
            // Load YouTube trailer
            self.trailerPlayer.load(withVideoId: tvShow.getYouTubeTrailer()?.key ?? "")
        }
    }
    
    func didSetCast(_ cast: [Cast]) {
        DispatchQueue.main.async {
            self.castCollectionView.reloadData()
        }
    }
}

extension TVShowDetailsViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tvShowManager.castCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.castCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cell.collectionCell, for: indexPath) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let cast = self.tvShowManager.getCast(at: indexPath.row) else { return cell }
        cell.setCast(cast)
        return cell
    }
}
