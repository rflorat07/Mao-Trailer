//
//  MovieListCollectionViewCell.swift
//  Mao Trailer
//
//  Created by Roger Florat on 21/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class MovieListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var rateView: UIView!
    
    var movie: Movie! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI() {
        
        rateView.isHidden = true
        titleLabel.text = movie.title?.uppercased()
        
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = Constants.cornerRadius
        coverImageView.image = UIImage(named: movie.imgUrl)
    }
}
