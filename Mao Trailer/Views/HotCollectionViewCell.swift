//
//  HotCollectionViewCell.swift
//  Mao Trailer
//
//  Created by Roger Florat on 19/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit
import Kingfisher

class HotCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterCoverView: UIView!
    @IBOutlet weak var coverImageView: UIImageView!
    
    let cornerRadius: CGFloat = Constants.cornerRadius
   
    var hotMovie: TVMovie! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI(){
                
        if hotMovie.title == "More" {
           coverImageView.image = UIImage(named: "land-more")
            
        } else {
            
           let imagePath = Helpers.downloadedFrom(urlString: hotMovie.backdrop_path ?? hotMovie.poster_path!)
            
            coverImageView.kf.setImage(with: URL(string: imagePath), placeholder: Constants.placeholderImage)
        }
        
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = Constants.cornerRadius
        
        posterCoverView.dropShadow(radius: Constants.cornerRadius)
    }
    
    override func prepareForReuse() {
         super.prepareForReuse()
        
        coverImageView.image = nil
    }
}
