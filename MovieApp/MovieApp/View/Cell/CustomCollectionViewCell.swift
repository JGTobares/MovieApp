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
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    public func configure(image: UIImage, title: String) {
        imageView.image = image
        labelTitle.text = title
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "CustomCollectionViewCell", bundle: nil)
    }
}
