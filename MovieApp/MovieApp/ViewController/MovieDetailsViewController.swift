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
    
    // MARK: - Constructors
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureButtons()
        manager.movieDetailsVCDelegate = self
        manager.getMovieDetails(id: self.movieID)
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
    
    func configureButtons() {
        self.backButton.setTitle("", for: .normal)
        self.backButton.addTarget(self, action: #selector(onBackPressed), for: .touchUpInside)
        self.infoButton.addTarget(self, action: #selector(onInfoPressed), for: .touchUpInside)
        self.castButton.addTarget(self, action: #selector(onCastPressed), for: .touchUpInside)
        self.trailerButton.addTarget(self, action: #selector(onTrailerPressed), for: .touchUpInside)
        
        // Show Info Tab first
        self.infoContainer.isHidden = false
        self.castContainer.isHidden = true
        self.trailerContainer.isHidden = true
        
        // Add red bottom border to selected button
        self.addBottomBorder(view: self.infoButton, tag: Constants.MovieDetails.infoTabTag, width: UIScreen.main.nativeBounds.width / 3)
        self.tabShown = Constants.MovieDetails.infoTabTag
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
