//
//  TodayCollectionViewCell.swift
//  TodayExtension
//
//  Created by Roger Florat on 03/09/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit
import Kingfisher

class TodayCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var posterCoverView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var item: Movie! {
        didSet {
            self.updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.text = ""
    
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = Constants.cornerRadius
        coverImageView.image = Constants.placeholderImage
        
        posterCoverView.dropShadow(radius: Constants.cornerRadius)
        
    }
    
    func updateUI() {
        
        titleLabel.text = item.title
    
        let imagePath = Helpers.getImagePath(urlString: item.poster_path ?? item.backdrop_path!)
        
        coverImageView.kf.setImage(with: URL(string: imagePath), placeholder: Constants.placeholderImage)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.image = nil
    }
}
