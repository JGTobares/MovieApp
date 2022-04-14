//
//  ViewController.swift
//  MovieApp
//
//  Created by Julio Gabriel Tobares on 12/04/2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var NowMovies: UICollectionView!
    @IBOutlet var PopularMovies: UICollectionView!
    @IBOutlet var UpcomingMovies: UICollectionView!
    let movieManager: MovieManager = MovieManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        movieManager.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 133, height: 186)
        layout.scrollDirection = .horizontal
        
        NowMovies.collectionViewLayout = layout
        NowMovies.register(CustomCollectionViewCell.nib(), forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        NowMovies.delegate = self
        NowMovies.dataSource = self
        
        PopularMovies.collectionViewLayout = layout
        PopularMovies.register(CustomCollectionViewCell.nib(), forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        PopularMovies.delegate = self
        PopularMovies.dataSource = self
        
        UpcomingMovies.collectionViewLayout = layout
        UpcomingMovies.register(CustomCollectionViewCell.nib(), forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        UpcomingMovies.delegate = self
        UpcomingMovies.dataSource = self
        
        movieManager.loadNowMovies()
        movieManager.loadPopularMovies()
        movieManager.loadUpcomingMovies()
    }

    func refreshMovies() {
        DispatchQueue.main.async { [weak self] in
            self?.NowMovies.reloadData()
            self?.PopularMovies.reloadData()
            self?.UpcomingMovies.reloadData()
        }
    }
    /*
    func refreshPopularMovies() {
        DispatchQueue.main.async { [weak self] in
            self?.PopularMovies.reloadData()
        }
    }
    func refreshUpcomingMovies() {
        DispatchQueue.main.async { [weak self] in
            self?.UpcomingMovies.reloadData()
        }
    }
     */
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NowMovies.deselectItem(at: indexPath, animated: true)
        
        print("Item pressed")
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.NowMovies {
            return movieManager.nowMovieCount
        } else if collectionView == self.PopularMovies {
            return movieManager.popularMovieCount
        } else {
            return movieManager.upcomingMovieCount
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.NowMovies {
            let cell = NowMovies.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as! CustomCollectionViewCell
            let movie = movieManager.nowMovies[indexPath.row]
            cell.configure(image: UIImage(named: "emptyImage")!, title: movie.title ?? "Empty")
            return cell
        } else if collectionView == self.PopularMovies {
            let cell = PopularMovies.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as! CustomCollectionViewCell
            let movie = movieManager.popularMovies[indexPath.row]
            cell.configure(image: UIImage(named: "emptyImage")!, title: movie.title ?? "Empty")
            return cell
        } else {
            let cell = UpcomingMovies.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as! CustomCollectionViewCell
            let movie = movieManager.upcomingMovies[indexPath.row]
            cell.configure(image: UIImage(named: "emptyImage")!, title: movie.title ?? "Empty")
            return cell
        }
    }
}

extension ViewController: MovieManagerDelegate {
    func onPopularLoaded(movie: Result<[Movie], CustomError>) {
        refreshMovies()
    }
    
    func onUpcomingLoaded(movie: Result<[Movie], CustomError>) {
        refreshMovies()
    }
    
    func onNowLoaded(movie: Result<[Movie], CustomError>) {
        refreshMovies()
    }
}

//extension ViewController: UICollectionViewFlowLayout {}
