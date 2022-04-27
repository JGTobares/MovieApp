//
//  Extensions.swift
//  MovieApp
//
//  Created by Julio Gabriel Tobares on 18/04/2022.
//

import Foundation
import UIKit
import Kingfisher

// MARK: - UIImageView
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

// MARK: - UIViewController
extension UIViewController: ErrorAlertDelegate {
    
    func showAlertMessage(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Constants.General.okLabel, style: .cancel, handler: { _ in
                alert.dismiss(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - URL
extension URL {
    
    mutating func appendQueryItem(name: String, value: String?) {
        guard var urlComponents = URLComponents(string: absoluteString) else { return }
        var queryItems: [URLQueryItem] = urlComponents.queryItems ?? []
        let queryItem = URLQueryItem(name: name, value: value)
        queryItems.append(queryItem)
        urlComponents.queryItems = queryItems
        if let url = urlComponents.url {
            self = url
        }
    }
}
