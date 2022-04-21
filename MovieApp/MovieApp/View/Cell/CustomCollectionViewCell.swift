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
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    // MARK: - Functions
    static func nib() -> UINib {
        return UINib(nibName: Constants.Cell.collectionCell, bundle: nil)
    }
}
