//
//  MovieDetailsViewController.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 14/04/22.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    // MARK: - Constants
    let repository = MovieDetailsRepository()
    
    // MARK: - Variables
    var movieID: Int?
    
    // MARK: - Outlets
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieTaglineLabel: UILabel!
    @IBOutlet weak var movieGenresLabel: UILabel!
    @IBOutlet weak var movieDirectorLabel: UILabel!
    @IBOutlet weak var movieOverviewLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        repository.movieDetailsVCDelegate = self
        repository.getMovieDetails(id: self.movieID)
    }
}

extension MovieDetailsViewController: MovieDetailsViewControllerDelegate {
    
    func didSetMovie() {
        DispatchQueue.main.async {
            self.backgroundImageView.image = UIImage(named: self.repository.movie?.backdropPath ?? "") ?? nil
            self.posterImageView.image = UIImage(named: self.repository.movie?.posterPath ?? "") ?? nil
            self.movieTitleLabel.text = self.repository.movie?.title ?? ""
            self.movieTaglineLabel.text = self.repository.movie?.tagline ?? ""
            self.movieGenresLabel.text = self.repository.movie?.getGenres()
            let director = self.repository.movie?.getDirector() ?? ""
            if director.isEmpty {
                self.movieDirectorLabel.text = ""
            } else {
                self.movieDirectorLabel.text = "Director: \(director)"
            }
            self.movieOverviewLabel.text = self.repository.movie?.overview ?? ""
        }
    }
}
