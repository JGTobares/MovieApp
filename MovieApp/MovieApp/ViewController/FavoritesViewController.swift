//
//  FavoritesViewController.swift
//  MovieApp
//
//  Created by Julio Gabriel Tobares on 19/04/2022.
//

import UIKit

class Favorites {
    var favoriteType: String?
    var favoritesMovies: [Movie]?
    
    init(favoriteType: String, favoritesMovies: [Movie]) {
        self.favoriteType = favoriteType
        self.favoritesMovies = favoritesMovies
    }
}

class FavoritesViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet var emptyMessage: UILabel!
    @IBOutlet var favoritesTableView: UITableView!
    
    // MARK: - Constants
    let movieManager: MovieManager = MovieManager()
    let storageManager: StorageManager = StorageManager()
    
    // MARK: - Variables
    var favoritesMock = [Favorites]()
    
    // MARK: - Initializers
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationItem.leftBarButtonItem = nil
        //self.navigationItem.hidesBackButton = false
        
        movieManager.delegate = self
        movieManager.loadNowMovies()
        movieManager.loadPopularMovies()
        
        favoritesTableView.register(CustomTableViewCell.nib(), forCellReuseIdentifier: Constants.Cell.tableCell)
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
        
        emptyMessage.isHidden = true
        
        self.configureObservers()
    }
    
    // MARK: - Functions
    func refreshFavorites() {
        DispatchQueue.main.async { [weak self] in
            self?.favoritesTableView.reloadData()
        }
    }
    
    func configureObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(deleteFavoriteItem(notification:)), name: Notification.Name(Constants.NotificationNameKeys.updateFavoriteItem), object: nil)
    }
    
    @objc func deleteFavoriteItem(notification: NSNotification) {
        if let itemId = notification.userInfo?[Constants.NotificationNameKeys.updateFavoriteItem] as? Int {
            print(itemId)
        }
    }
}

// MARK: - Extensions
extension FavoritesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return favoritesMock.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesMock[section].favoritesMovies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoritesTableView.dequeueReusableCell(withIdentifier: Constants.Cell.tableCell, for: indexPath) as! CustomTableViewCell
        let item = favoritesMock[indexPath.section].favoritesMovies?[indexPath.row]
        cell.item = item
        cell.frame = cell.frame.inset(by: UIEdgeInsets(top: 5, left: 30, bottom: 5, right: 0))
        return cell
    }
    
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        favoritesTableView.deselectRow(at: indexPath, animated: true)
        let movie: Movie
        movie = self.movieManager.nowMovies[indexPath.row]
        let vc = MovieDetailsViewController()
        vc.movieID = movie.id
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 160))
        view.backgroundColor = .gray
        
        let title = UILabel(frame: CGRect(x: 15, y: 0, width: view.frame.width - 15, height: 30))
        title.text = favoritesMock[section].favoriteType
        title.textColor = .white
        view.addSubview(title)
        return view
    }
    
}

extension FavoritesViewController: MovieManagerDelegate {
    func onNowLoaded() {
        favoritesMock.append(Favorites.init(favoriteType: "Movies", favoritesMovies: movieManager.nowMovies))
        refreshFavorites()
    }
    
    func onPopularLoaded() {
        favoritesMock.append(Favorites.init(favoriteType: "TV Shows", favoritesMovies: movieManager.popularMovies))
        refreshFavorites()
    }
    
    func onUpcomingLoaded() {}
}

