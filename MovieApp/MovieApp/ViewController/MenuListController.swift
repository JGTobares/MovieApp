//
//  MenuListController.swift
//  MovieApp
//
//  Created by Julio Gabriel Tobares on 19/04/2022.
//

import Foundation
import UIKit

class MenuListController: UITableViewController {
    
    //MARK: - Variables
    var pages = [Constants.SideMenu.movies, Constants.SideMenu.tvShows, Constants.SideMenu.favorites]
    var darkColor = UIColor(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1)
    
    //MARK: - Initializers
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = darkColor
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    //MARK: - Functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
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
            let story = UIStoryboard(name: "Main", bundle:nil)
            let vc = story.instantiateViewController(withIdentifier: "movieVC") as! ViewController
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case Constants.SideMenu.tvShows:
            let story = UIStoryboard(name: "Main", bundle:nil)
            let vc = story.instantiateViewController(withIdentifier: "tvShowVC") as! TVShowsViewController
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case Constants.SideMenu.favorites:
            let story = UIStoryboard(name: "Main", bundle:nil)
            let vc = story.instantiateViewController(withIdentifier: "favoritesVC") as! FavoritesViewController
            self.navigationController?.pushViewController(vc, animated: true)
            break
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
    }
}
