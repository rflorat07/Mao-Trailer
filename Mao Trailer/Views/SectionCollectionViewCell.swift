//
//  SectionCollectionViewCell.swift
//  Mao Trailer
//
//  Created by Roger Florat on 20/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class SectionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterCoverView: UIView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var rateView: UIView!
    
    let cornerRadius: CGFloat = Constants.cornerRadius
    
    var sectionMovie: Movie! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI() {
        
        if sectionMovie.title != "More" {
            
            titleLabel.text = sectionMovie.title?.uppercased()
            rateLabel.text = String(format:"%.1f", sectionMovie.rate!)
            
        } else {
            titleLabel.text = ""
            rateView.isHidden = true
            
        }
        
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = cornerRadius
        coverImageView.image = UIImage(named: sectionMovie.imgUrl)
        
      //  posterCoverView.dropShadow(radius: cornerRadius)
        
    }
}
