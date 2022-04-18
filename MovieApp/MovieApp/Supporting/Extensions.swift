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
            let imgUrl = Constants.Url.urlBasePoster + imgURL
            self.kf.setImage(with: URL(string: imgUrl), placeholder: UIImage(named: Constants.Images.placeholder), options: nil, progressBlock: nil, completionHandler: nil)
        } else {
            self.image = UIImage(named: Constants.Images.emptyImage)
        }
    }
    
    func setBackground(imageurl: String?) {
        if let imgURL = imageurl {
            let imgUrl = Constants.Url.urlBaseBackground + imgURL
            self.kf.setImage(with: URL(string: imgUrl), placeholder: UIImage(named: Constants.Images.placeholder), options: nil, progressBlock: nil, completionHandler: nil)
        } else {
            self.image = UIImage(named: Constants.Images.emptyImage)
        }
    }
}
