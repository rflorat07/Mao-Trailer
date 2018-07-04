//
//  TVNowCollectionViewCell.swift
//  Mao Trailer
//
//  Created by Roger Florat on 21/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class TVNowCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterCoverView: UIView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var rateView: UIView!
    
    let cornerRadius: CGFloat = Constants.cornerRadius
    
    var nowMovie: Movie!{
        didSet{
            self.updateUI()
        }
    }
    
    func updateUI() {
        
        if nowMovie.title != "More" {
            
            rateView.isHidden = true
            titleLabel.text = nowMovie.title.uppercased()
            
        } else {
            titleLabel.text = ""
            rateView.isHidden = true
        }
        
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = cornerRadius
        coverImageView.image = UIImage(named: nowMovie.poster_path)
        
        posterCoverView.dropShadow(radius: cornerRadius)
        
        
    }
    
}
