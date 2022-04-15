//
//  ViewController.swift
//  MovieApp
//
//  Created by Julio Gabriel Tobares on 12/04/2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var nowMovies: UICollectionView!
    @IBOutlet var popularMovies: UICollectionView!
    @IBOutlet var upcomingMovies: UICollectionView!
    let movieManager: MovieManager = MovieManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        movieManager.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 133, height: 186)
        layout.scrollDirection = .horizontal
        
        nowMovies.collectionViewLayout = layout
        nowMovies.register(CustomCollectionViewCell.nib(), forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        nowMovies.delegate = self
        nowMovies.dataSource = self
        
        popularMovies.collectionViewLayout = layout
        popularMovies.register(CustomCollectionViewCell.nib(), forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        popularMovies.delegate = self
        popularMovies.dataSource = self
        
        upcomingMovies.collectionViewLayout = layout
        upcomingMovies.register(CustomCollectionViewCell.nib(), forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        upcomingMovies.delegate = self
        upcomingMovies.dataSource = self
        
        movieManager.loadNowMovies()
        movieManager.loadPopularMovies()
        movieManager.loadUpcomingMovies()
    }

    func refreshMovies() {
        DispatchQueue.main.async { [weak self] in
            self?.nowMovies.reloadData()
            self?.popularMovies.reloadData()
            self?.upcomingMovies.reloadData()
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        nowMovies.deselectItem(at: indexPath, animated: true)
        
        print("Item pressed")
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.nowMovies {
            return movieManager.nowMovieCount
        } else if collectionView == self.popularMovies {
            return movieManager.popularMovieCount
        } else {
            return movieManager.upcomingMovieCount
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.nowMovies {
            let cell = nowMovies.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as! CustomCollectionViewCell
            let movie = movieManager.nowMovies[indexPath.row]
            cell.configure(image: UIImage(named: "emptyImage")!, title: movie.title ?? "Empty")
            return cell
        } else if collectionView == self.popularMovies {
            let cell = popularMovies.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as! CustomCollectionViewCell
            let movie = movieManager.popularMovies[indexPath.row]
            cell.configure(image: UIImage(named: "emptyImage")!, title: movie.title ?? "Empty")
            return cell
        } else {
            let cell = upcomingMovies.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as! CustomCollectionViewCell
            let movie = movieManager.upcomingMovies[indexPath.row]
            cell.configure(image: UIImage(named: "emptyImage")!, title: movie.title ?? "Empty")
            return cell
        }
    }
}

extension ViewController: MovieManagerDelegate {
    
    func onNowLoaded() {
        refreshMovies()
    }
    
    func onPopularLoaded() {
        refreshMovies()
    }
    
    func onUpcomingLoaded() {
        refreshMovies()
    }
}
