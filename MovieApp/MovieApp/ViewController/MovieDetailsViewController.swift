//
//  MovieDetailsViewController.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 14/04/22.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    // MARK: - Constants
    let manager = MovieDetailsManager()
    
    // MARK: - Variables
    var movieID: Int?
    
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
    
    // MARK: - Constructors
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backButton.setTitle("", for: .normal)
        self.backButton.addTarget(self, action: #selector(onBackPressed), for: .touchUpInside)
        manager.movieDetailsVCDelegate = self
        manager.getMovieDetails(id: self.movieID)
    }
    
    // MARK: - Functions
    @objc func onBackPressed() {
        self.dismiss(animated: true)
    }
}

// MARK: - Extensions
extension MovieDetailsViewController: MovieDetailsViewControllerDelegate {
    
    func didSetMovie() {
        DispatchQueue.main.async {
            self.backgroundImageView.image = UIImage(named: self.manager.movie?.backdropPath ?? "") ?? nil
            self.posterImageView.image = UIImage(named: self.manager.movie?.posterPath ?? "") ?? nil
            self.movieTitleLabel.text = self.manager.movie?.title ?? ""
            self.movieTaglineLabel.text = self.manager.movie?.tagline ?? ""
            self.movieGenresLabel.text = self.manager.movie?.getGenres()
            let director = self.manager.movie?.getDirector() ?? ""
            if director.isEmpty {
                self.movieDirectorLabel.text = ""
            } else {
                self.movieDirectorLabel.text = String.localizedStringWithFormat(Constants.MovieDetails.directorLabel, director)
            }
            self.movieDateLabel.text = String.localizedStringWithFormat(Constants.MovieDetails.releaseDateLabel, self.manager.movie?.getFormattedReleaseDate() ?? "")
            self.movieRuntimeLabel.text = String.localizedStringWithFormat(Constants.MovieDetails.runtimeLabel, self.manager.movie?.getRuntimeString() ?? "")
            self.movieOverviewLabel.text = self.manager.movie?.overview ?? ""
            self.movieStatusLabel.text = String.localizedStringWithFormat(Constants.MovieDetails.statusLabel, self.manager.movie?.status ?? Constants.MovieDetails.statusUnknown)
            // Make text italics and underlined
            self.movieWebpageLabel.attributedText = NSAttributedString(string: self.manager.movie?.homepage ?? "", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
            self.movieWebpageLabel.font = UIFont.italicSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize)
        }
    }
}
