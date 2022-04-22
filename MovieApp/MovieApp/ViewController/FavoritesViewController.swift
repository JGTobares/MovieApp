//
//  FavoritesViewController.swift
//  MovieApp
//
//  Created by Julio Gabriel Tobares on 19/04/2022.
//

import UIKit

class FavoritesViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet var emptyMessage: UILabel!
    @IBOutlet var favoritesTableView: UITableView!
    
    // MARK: - Constants
    let manager = FavoritesManager()
    
    
    // MARK: - Initializers
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        manager.getFavorites()
        configureObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoritesTableView.register(CustomTableViewCell.nib(), forCellReuseIdentifier: Constants.Cell.tableCell)
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
        
        emptyMessage.text = ""
        manager.delegate = self
        manager.getFavorites()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
     }
    
    // MARK: - Functions
    func refreshFavorites() {
        DispatchQueue.main.async { [weak self] in
            self?.favoritesTableView.reloadData()
            if self?.manager.noFavorites == true {
                self?.emptyMessage.text = Constants.Favorites.noFavoritesMessage
            } else {
                self?.emptyMessage.text = ""
            }
        }
    }
    
    func configureObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(deleteFavoriteItem(notification:)), name: Notification.Name(Constants.NotificationNameKeys.updateFavoriteItem), object: nil)
    }
    
    @objc func deleteFavoriteItem(notification: NSNotification) {
        if let itemId = notification.userInfo?[Constants.NotificationNameKeys.updateFavoriteItem] as? Int {
            manager.updateFavoriteStatus(id: itemId, isFavorite: false)
        }
    }
}

// MARK: - Extensions
extension FavoritesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return manager.sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.getRowsOfSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoritesTableView.dequeueReusableCell(withIdentifier: Constants.Cell.tableCell, for: indexPath) as! CustomTableViewCell
        guard let movie = self.manager.getFavorite(section: indexPath.section, row: indexPath.row) as? Movie else {
            return UITableViewCell()
        }
        cell.item = movie
        cell.frame = cell.frame.inset(by: UIEdgeInsets(top: 5, left: 30, bottom: 5, right: 0))
        return cell
    }
}

extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        favoritesTableView.deselectRow(at: indexPath, animated: true)
        guard let movie = self.manager.getFavorite(section: indexPath.section, row: indexPath.row) as? Movie else {
            return
        }
        let vc = MovieDetailsViewController()
        vc.movieID = movie.id
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 160))
        view.backgroundColor = .gray
        
        let title = UILabel(frame: CGRect(x: 15, y: 0, width: view.frame.width - 15, height: 30))
        title.text = manager.getTitleOfSection(section)
        title.textColor = .white
        view.addSubview(title)
        return view
    }
}

extension FavoritesViewController: FavoritesManagerDelegate {
    
    func onLoadFavorites() {
        self.refreshFavorites()
    }
    
    func onUpdateFavorites() {
        self.refreshFavorites()
    }
}

