//
//  MenuListController.swift
//  MovieApp
//
//  Created by Julio Gabriel Tobares on 19/04/2022.
//

import Foundation
import UIKit

class MenuListController: UITableViewController {
    
    //MARK: - Constants
    let pages = [Constants.SideMenu.movies, Constants.SideMenu.tvShows, Constants.SideMenu.favorites]
    let darkColor = Constants.SideMenu.darkColor
    
    //MARK: - Initializers
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = darkColor
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.SideMenu.cell)
    }

    //MARK: - Functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.SideMenu.cell, for: indexPath)
        cell.textLabel?.text = pages[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.backgroundColor = darkColor
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let id = pages[indexPath.row]
        switch id {
        case Constants.SideMenu.movies:
            
            let story = UIStoryboard(name: Constants.SideMenu.main, bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: Constants.SideMenu.movieVC) as! ViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
            //self.showViewController(viewController: UINavigationController.self, storyboardId: "HomeNavID")
            break
        case Constants.SideMenu.tvShows:
            
            let story = UIStoryboard(name: Constants.SideMenu.main, bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: Constants.SideMenu.tvShowVC) as! TVShowsViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
            //self.showViewController(viewController: UINavigationController.self, storyboardId: "FavoriteNavID")
            break
        case Constants.SideMenu.favorites:
            
            let story = UIStoryboard(name: Constants.SideMenu.main, bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: Constants.SideMenu.favoritesVC) as! FavoritesViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
            //self.showViewController(viewController: UINavigationController.self, storyboardId: "TVShowNavID")
            break
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
    }
}
