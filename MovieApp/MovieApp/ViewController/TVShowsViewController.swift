//
//  TVShowsViewController.swift
//  MovieApp
//
//  Created by Julio Gabriel Tobares on 19/04/2022.
//

import UIKit

class TVShowsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        load()

    }
    
    func load() {
        let vc = TVShowDetailsViewController.init(nibName: Constants.Nib.details, bundle: nil)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}
