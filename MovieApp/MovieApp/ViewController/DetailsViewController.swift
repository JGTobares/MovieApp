//
//  MovieDetailsViewController.swift
//  MovieApp
//
//  Created by Fernando Guerrero on 14/04/22.
//

import UIKit
import youtube_ios_player_helper

class DetailsViewController: UIViewController {
    
    // MARK: - Constants
    let manager = MovieManager()
    
    // MARK: - Variables
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
        self.configureButtons()
        self.configureObservers()
        manager.setErrorDelegate(self)
        self.trailerPlayer.delegate = self
        castCollectionView.register(CustomCollectionViewCell.nib(), forCellWithReuseIdentifier: Constants.Cell.collectionCell)
        castCollectionView.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Functions
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        // Adjust bottom border when device is rotated
        switch self.tabShown {
        case Constants.Details.infoTabTag:
            self.infoButton.subviews.first(where: { $0.tag == Constants.Details.infoTabTag })?.removeFromSuperview()
            self.addBottomBorder(view: self.infoButton, tag: Constants.Details.infoTabTag, width: size.width / 3)
            break
        case Constants.Details.castTabTag:
            self.castButton.subviews.first(where: { $0.tag == Constants.Details.castTabTag })?.removeFromSuperview()
            self.addBottomBorder(view: self.castButton, tag: Constants.Details.castTabTag, width: size.width / 3)
            break
        case Constants.Details.trailerTabTag:
            self.trailerButton.subviews.first(where: { $0.tag == Constants.Details.trailerTabTag })?.removeFromSuperview()
            self.addBottomBorder(view: self.trailerButton, tag: Constants.Details.trailerTabTag, width: size.width / 3)
            break
        default:
            break
        }
    }
    
    func configureObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(showOfflineToast(notification: )), name: Notification.Name(Constants.Network.updateNetworkStatus), object: nil)
    }
    
    @objc func showOfflineToast(notification: NSNotification) {
        CustomToast.show(message: Constants.Network.toastOfflineStatus, bgColor: .red, textColor: .white, labelFont: .boldSystemFont(ofSize: 16), showIn: .bottom, controller: self)
        self.trailerPlayer.isHidden = true
        self.trailerErrorLabel.text = Constants.Details.trailerErrorMessage
        NotificationCenter.default.removeObserver(self)
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
        self.addBottomBorder(view: self.infoButton, tag: Constants.Details.infoTabTag, width: UIScreen.main.bounds.width / 3)
        self.tabShown = Constants.Details.infoTabTag
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
        if self.tabShown == Constants.Details.infoTabTag {
            return
        }
        self.infoContainer.isHidden = false
        self.castContainer.isHidden = true
        self.trailerContainer.isHidden = true
        self.addBottomBorder(view: self.infoButton, tag: Constants.Details.infoTabTag)
        self.castButton.subviews.first(where: { $0.tag == Constants.Details.castTabTag })?.removeFromSuperview()
        self.trailerButton.subviews.first(where: { $0.tag == Constants.Details.trailerTabTag })?.removeFromSuperview()
        self.tabShown = Constants.Details.infoTabTag
    }
    
    @objc func onCastPressed() {
        if self.tabShown == Constants.Details.castTabTag {
            return
        }
        self.infoContainer.isHidden = true
        self.castContainer.isHidden = false
        self.trailerContainer.isHidden = true
        self.addBottomBorder(view: self.castButton, tag: Constants.Details.castTabTag)
        self.infoButton.subviews.first(where: { $0.tag == Constants.Details.infoTabTag })?.removeFromSuperview()
        self.trailerButton.subviews.first(where: { $0.tag == Constants.Details.trailerTabTag })?.removeFromSuperview()
        self.tabShown = Constants.Details.castTabTag
    }
    
    @objc func onTrailerPressed() {
        if self.tabShown == Constants.Details.trailerTabTag {
            return
        }
        self.infoContainer.isHidden = true
        self.castContainer.isHidden = true
        self.trailerContainer.isHidden = false
        self.addBottomBorder(view: self.trailerButton, tag: Constants.Details.trailerTabTag)
        self.castButton.subviews.first(where: { $0.tag == Constants.Details.castTabTag })?.removeFromSuperview()
        self.infoButton.subviews.first(where: { $0.tag == Constants.Details.infoTabTag })?.removeFromSuperview()
        self.tabShown = Constants.Details.trailerTabTag
    }
    
    //MARK: - Outlets
    @IBAction func didTapHeart(_ sender: Any) {
        if (self.heartButton.tintColor == .lightGray) {
            self.heartButton.tintColor = .red
        } else {
            self.heartButton.tintColor = .lightGray
        }
    }
}

// MARK: - Extensions
extension DetailsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.manager.castCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.castCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cell.collectionCell, for: indexPath) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setCast(self.manager.getCast(at: indexPath.row))
        return cell
    }
}

extension DetailsViewController: YTPlayerViewDelegate {
    
    func playerViewPreferredWebViewBackgroundColor(_ playerView: YTPlayerView) -> UIColor {
        return .black
    }
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        self.trailerPlayer.isHidden = false
        self.trailerErrorLabel.text = ""
    }
    
    func playerView(_ playerView: YTPlayerView, receivedError error: YTPlayerError) {
        self.trailerPlayer.isHidden = true
        self.trailerErrorLabel.text = Constants.Details.trailerErrorMessage
    }
}
