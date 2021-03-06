//
//  SectionCollectionViewCell.swift
//  Mao Trailer
//
//  Created by Roger Florat on 20/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit
import Kingfisher

class SectionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterCoverView: UIView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var rateView: UIView!
    
    let cornerRadius: CGFloat = Constants.cornerRadius
    
    var sectionMovie: TVMovie! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI() {
        
        if sectionMovie.title != "More" {
            
            titleLabel.text = sectionMovie.title.uppercased()
            rateLabel.text = String(format:"%.1f", sectionMovie.vote_average)
            
            let imagePath = Helpers.downloadedFrom(urlString: sectionMovie.poster_path ?? sectionMovie.backdrop_path!)
            
            coverImageView.kf.setImage(with: URL(string: imagePath), placeholder: Constants.placeholderImage)
            
        } else {
            
            titleLabel.text = ""
            rateView.isHidden = true
            coverImageView.image = UIImage(named: "port-more")
        }
        
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = cornerRadius
        
        posterCoverView.dropShadow(radius: cornerRadius)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = ""
        rateLabel.text = "0.0"
        coverImageView.image = nil
    }
    
}








