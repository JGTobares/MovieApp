//
//  CustomCollectionViewCell.swift
//  MovieApp
//
//  Created by Julio Gabriel Tobares on 14/04/2022.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var labelTitle: UILabel!
    
    static let identifier = "CustomCollectionViewCell"
    
    var card: Movie! {
        didSet {
            self.labelTitle.text = self.card.title
            self.imageView.setImage(imageurl: self.card.posterPath)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    public func emptyImg(image: UIImage) {
        imageView.image = image
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "CustomCollectionViewCell", bundle: nil)
    }
}
