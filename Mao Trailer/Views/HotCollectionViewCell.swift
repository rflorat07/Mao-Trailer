//
//  HotCollectionViewCell.swift
//  Mao Trailer
//
//  Created by Roger Florat on 19/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class HotCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var posterCoverView: UIView!
    @IBOutlet weak var coverImageView: UIImageView!
    
    let cornerRadius: CGFloat = Constants.cornerRadius
    
    var hotMovie: Movie! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI(){
        
        coverImageView.clipsToBounds = true
        coverImageView.image = UIImage(named: hotMovie.imgUrl)
        coverImageView.layer.cornerRadius = Constants.cornerRadius
        
        posterCoverView.dropShadow(radius: Constants.cornerRadius)
    }
    
}
