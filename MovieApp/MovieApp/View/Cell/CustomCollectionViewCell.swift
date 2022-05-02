//
//  CustomCollectionViewCell.swift
//  MovieApp
//
//  Created by Julio Gabriel Tobares on 14/04/2022.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var labelTitle: UILabel!
    
    // MARK: - Variables
    var card: Movie! {
        didSet {
            self.labelTitle.text = self.card.title
            self.imageView.setImage(imageurl: self.card.posterPath)
        }
    }
    
    var tvShow: TVShow! {
        didSet {
            self.labelTitle.text = self.tvShow.title
            self.imageView.setImage(imageurl: self.tvShow.posterPath)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Functions
    static func nib() -> UINib {
        return UINib(nibName: Constants.Cell.collectionCell, bundle: nil)
    }
    
    func setCast(_ cast: Cast) {
        self.imageView.setImage(imageurl: cast.profilePath)
        if let name = cast.name, !name.isEmpty {
            if let character = cast.character, !character.isEmpty {
                self.labelTitle.text = String(format: Constants.Cell.castLabelFormat, name, character)
            } else {
                self.labelTitle.text = name
            }
        }
        self.labelTitle.font = self.labelTitle.font.withSize(10.0)
    }
}
