//
//  TVShowDetailsViewController.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 29/04/22.
//

import UIKit

class TVShowDetailsViewController: DetailsViewController {
    
    // MARK: - Variables
    var tvShowId: Int? = 92749
    
    
    // MARK: - Initializers
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.setDetailsDelegate(self)
        manager.getData(tvShowID: self.tvShowId)
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
