//
//  ListCollectionViewCell.swift
//  Mao Trailer
//
//  Created by Roger Florat on 21/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit
import Kingfisher

class ListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterCoverView: UIView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var rateView: UIView!
    
    var movie: TVMovie! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI() {
        
        let imagePath = Helpers.downloadedFrom(urlString: movie.poster_path ?? movie.backdrop_path!)
        
        rateLabel.text = movie.getRatingValue()
        titleLabel.text = movie.title.uppercased()
        
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = Constants.cornerRadius
        coverImageView.kf.setImage(with: URL(string: imagePath), placeholder: Constants.placeholderImage)
        
        posterCoverView.dropShadow(radius: Constants.cornerRadius)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = ""
        rateLabel.text = "0.0"
        coverImageView.image = nil
    }
}
