//
//  SectionCollectionViewCell.swift
//  Mao Trailer
//
//  Created by Roger Florat on 20/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class SectionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var rateLabel: UILabel!
    
    
    var sectionMovie: Movie! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI() {
        
        let cornerRadius: CGFloat = 6
        
        
        titleLabel.text = sectionMovie.title?.uppercased()
        rateLabel.text = String(format:"%.1f", sectionMovie.rate!)
        
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = cornerRadius
        coverImageView.image = UIImage(named: sectionMovie.imgUrl)
        
        
        // Shadow
        /* coverView.layer.shadowRadius = 5
         coverView.layer.shadowOpacity = 1
         coverView.layer.masksToBounds = false
         coverView.layer.shadowColor = UIColor.black.cgColor
         coverView.layer.shadowOffset = CGSize(width: 0, height: 3.0) */
    }
}
