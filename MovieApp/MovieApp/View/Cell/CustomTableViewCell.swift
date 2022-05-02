//
//  CustomTableViewCell.swift
//  MovieApp
//
//  Created by Julio Gabriel Tobares on 20/04/2022.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet var favoriteImage: UIImageView!
    @IBOutlet var favoriteTitle: UILabel!
    @IBOutlet var favoriteCategory: UILabel!
    
    //MARK: - Variables
    var itemId: Int?
    var type: String = ""
    var item: Movie! {
        didSet {
            self.itemId = self.item.id
            self.type = Constants.SideMenu.movies
            self.favoriteTitle.text = self.item.title
            self.favoriteImage.setImage(imageurl: self.item.posterPath)
            self.favoriteCategory.text = self.item.overview
        }
    }
    var show: TVShow! {
        didSet {
            self.itemId = self.show.id
            self.type = Constants.SideMenu.favorites
            self.favoriteTitle.text = self.show.title
            self.favoriteImage.setImage(imageurl: self.show.posterPath)
            self.favoriteCategory.text = self.show.overview
        }
    }

    //MARK: - Functions
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: Constants.Cell.tableCell, bundle: nil)
    }
    
    //MARK: - Outlets
    @IBAction func didTapHeart(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name(Constants.NotificationNameKeys.updateFavoriteItem), object: nil, userInfo:
                                            [Constants.NotificationNameKeys.updateFavoriteItem: itemId ?? 0,
                                             Constants.NotificationNameKeys.favoriteTypeItem: type])
    }
}
