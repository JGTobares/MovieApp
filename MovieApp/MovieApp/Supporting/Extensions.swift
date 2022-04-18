//
//  Extensions.swift
//  MovieApp
//
//  Created by Julio Gabriel Tobares on 18/04/2022.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    
    func setImage(imageurl: String?) {
        
        if let imgURL = imageurl {
            let imgUrl = Constants.MovieDetails.urlBasePoster + imgURL
            self.kf.setImage(with: URL(string: imgUrl), placeholder: UIImage(named: Constants.MovieDetails.placeholder), options: nil, progressBlock: nil, completionHandler: nil)
        } else {
            self.image = UIImage(named: Constants.MovieDetails.emptyImage)
        }
    }
    
    func setBackground(imageurl: String?) {
        
        if let imgURL = imageurl {
            let imgUrl = Constants.MovieDetails.urlBaseBackground + imgURL
            self.kf.setImage(with: URL(string: imgUrl), placeholder: UIImage(named: Constants.MovieDetails.placeholder), options: nil, progressBlock: nil, completionHandler: nil)
        } else {
            self.image = UIImage(named: Constants.MovieDetails.emptyImage)
        }
    }
}
