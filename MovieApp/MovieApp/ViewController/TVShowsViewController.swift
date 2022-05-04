//
//  TVShowsViewController.swift
//  MovieApp
//
//  Created by Julio Gabriel Tobares on 19/04/2022.
//

import UIKit

class TVShowsViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var posterImage: UIImageView!
    @IBOutlet var showTitle: UILabel!
    @IBOutlet var showCategory: UILabel!
    @IBOutlet var descriptionLbl: UILabel!
    @IBOutlet var viewDetailsBtn: UIButton!
    @IBOutlet var onTheAirButton: UIButton!
    @IBOutlet var popularButton: UIButton!
    @IBOutlet var onTheAirCollection: UICollectionView!
    @IBOutlet var popularCollection: UICollectionView!
    
    // MARK: - Constants
    let movieManager = TVShowManager()
    
    // MARK: - Variables
    var tabShown: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.backgroundColor = .black
        let attributes = [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font:UIFont(name: "Verdana-bold", size: 17)]
        self.navigationController?.navigationBar.titleTextAttributes = attributes as [NSAttributedString.Key : Any]

        //movieManager.setTVShowsDelegate(self)
        movieManager.tvShowsDelegate = self
        self.configureObservers()
        self.configureButtons()
        self.configureCollections()
        movieManager.getTVShows()
    }
    
    // MARK: - Functions
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        switch self.tabShown {
        case Constants.TVShows.onTheAir:
            self.onTheAirButton.subviews.first(where: { $0.tag == Constants.TVShows.onTheAirTag })?.removeFromSuperview()
            self.addBottomBorder(view: self.onTheAirButton, tag: Constants.TVShows.onTheAirTag, width: size.width / 2)
            break
        case Constants.TVShows.popular:
            self.popularButton.subviews.first(where: { $0.tag == Constants.TVShows.popularTag })?.removeFromSuperview()
            self.addBottomBorder(view: self.popularButton, tag: Constants.TVShows.popularTag, width: size.width / 2)
            break
        default:
            break
        }
    }
    
    func refreshShows() {
        DispatchQueue.main.async { [weak self] in
            self?.onTheAirCollection.reloadData()
            self?.popularCollection.reloadData()
        }
    }
    
    func refreshBanner() {
        DispatchQueue.main.async { [weak self] in
            guard let show: TVShow = self?.movieManager.tvShowBanner else {
                self?.posterImage.setImage(imageurl: nil)
                self?.backgroundImage.setBackground(imageurl: nil)
                self?.showTitle.text = ""
                self?.showCategory.text = ""
                self?.descriptionLbl.text = ""
                self?.viewDetailsBtn.isHidden = true
                return
            }
            self?.posterImage.setImage(imageurl: show.posterPath)
            self?.backgroundImage.setBackground(imageurl: show.backdropPath)
            self?.showTitle.text = show.title
            self?.showCategory.text = show.getGenres()
            self?.descriptionLbl.text = show.overview
        }
    }
    
    func configureButtons() {
        self.onTheAirButton.addTarget(self, action: #selector(onTheAirPressed), for: .touchUpInside)
        self.popularButton.addTarget(self, action: #selector(onPopularPressed), for: .touchUpInside)
        
        self.onTheAirCollection.isHidden = false
        self.popularCollection.isHidden = true
        
        self.addBottomBorder(view: self.onTheAirButton, tag: Constants.TVShows.onTheAirTag, width: UIScreen.main.bounds.width / 2)
        self.tabShown = Constants.TVShows.onTheAir
    }
    
    func addBottomBorder(view: UIView, tag: Int, width: CGFloat? = nil) {
        let width = width ?? view.frame.size.width
        let lineView = UIView(frame: CGRect(x: 0, y: view.frame.size.height - 2, width: width, height: 2))
        lineView.backgroundColor = .red
        lineView.tag = tag
        view.addSubview(lineView)
    }
    
    @objc func onTheAirPressed() {
        if self.tabShown == Constants.TVShows.onTheAir {
            return
        }
        self.onTheAirCollection.isHidden = false
        self.popularCollection.isHidden = true

        self.addBottomBorder(view: self.onTheAirButton, tag: Constants.TVShows.onTheAirTag)
        self.popularButton.subviews.first(where: { $0.tag == Constants.TVShows.popularTag })?.removeFromSuperview()
        self.tabShown = Constants.TVShows.onTheAir
    }
    
    @objc func onPopularPressed() {
        if self.tabShown == Constants.TVShows.popular {
            return
        }
        self.onTheAirCollection.isHidden = true
        self.popularCollection.isHidden = false

        self.addBottomBorder(view: self.popularButton, tag: Constants.TVShows.popularTag)
        self.onTheAirButton.subviews.first(where: { $0.tag == Constants.TVShows.onTheAirTag })?.removeFromSuperview()
        self.tabShown = Constants.TVShows.popular
    }
    
    func configureObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(showOfflineToast(notification:)), name: Notification.Name(Constants.Network.updateNetworkStatus), object: nil)
    }
    
    @objc func showOfflineToast(notification: NSNotification) {
        CustomToast.show(message: Constants.Network.toastOfflineStatus, bgColor: .red, textColor: .white, labelFont: .boldSystemFont(ofSize: 16), showIn: .bottom, controller: self)
        NotificationCenter.default.removeObserver(self)
    }
    
    func configureCollections() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: Constants.Cell.width, height: Constants.Cell.height)
        
        onTheAirCollection.collectionViewLayout = layout
        onTheAirCollection.register(CustomCollectionViewCell.nib(), forCellWithReuseIdentifier: Constants.Cell.collectionCell)
        onTheAirCollection.delegate = self
        onTheAirCollection.dataSource = self
        
        popularCollection.collectionViewLayout = layout
        popularCollection.register(CustomCollectionViewCell.nib(), forCellWithReuseIdentifier: Constants.Cell.collectionCell)
        popularCollection.delegate = self
        popularCollection.dataSource = self
    }
    
    @IBAction func didTapViewDetails(_ sender: Any) {
        guard let show: TVShow = movieManager.tvShowBanner else {
            return
        }
        let vc = TVShowDetailsViewController.init(nibName: Constants.Nib.details, bundle: nil)
        vc.tvShowId = show.id
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}


// MARK: - Extensions
extension TVShowsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onTheAirCollection.deselectItem(at: indexPath, animated: true)
        let show: TVShow
        if collectionView == self.onTheAirCollection {
            show = self.movieManager.getOnTheAirTVShow(at: indexPath.row)
        } else {
            show = self.movieManager.getPopularTVShow(at: indexPath.row)
        }
        movieManager.getTVShow(id: show.id)
    }
}

extension TVShowsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.onTheAirCollection {
            return movieManager.onTheAirTVShowCount
        } else {
            return movieManager.popularTVShowCount
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.onTheAirCollection {
            let cell = onTheAirCollection.dequeueReusableCell(withReuseIdentifier: Constants.Cell.collectionCell, for: indexPath) as! CustomCollectionViewCell
            let show = movieManager.getOnTheAirTVShow(at: indexPath.row)
            cell.tvShow = show
            return cell
        } else {
            let cell = popularCollection.dequeueReusableCell(withReuseIdentifier: Constants.Cell.collectionCell, for: indexPath) as! CustomCollectionViewCell
            let show = movieManager.getPopularTVShow(at: indexPath.row)
            cell.tvShow = show
            return cell
        }
    }
}

extension TVShowsViewController: TVShowManagerDelegate {
    func onBannerLoaded() {
        refreshBanner()
    }
    
    func onTheAirLoaded() {
        refreshShows()
    }
    
    func onPopularLoaded() {
        refreshShows()
    }
}
