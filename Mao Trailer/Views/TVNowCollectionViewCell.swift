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
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var rateView: UIView!
    
    var nowMovie: Movie!{
        didSet{
            self.updateUI()
        }
    }
    
    func updateUI() {
        
        let cornerRadius: CGFloat = 6
        
        rateView.isHidden = true
        titleLabel.text = nowMovie.title?.uppercased()
        
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = cornerRadius
        coverImageView.image = UIImage(named: nowMovie.imgUrl)
    }
    
}
