//
//  TVNowCollectionViewCell.swift
//  Mao Trailer
//
//  Created by Roger Florat on 21/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class TVNowCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterCoverView: UIView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var rateView: UIView!
    
    let cornerRadius: CGFloat = Constants.cornerRadius
    
    var nowTVShow: TVMovie!{
        didSet{
            self.updateUI()
        }
    }
    
    func updateUI() {
        
        if nowTVShow.title != "More" {
            
            rateView.isHidden = true
            titleLabel.text = nowTVShow.title.uppercased()
            
            coverImageView.downloadedFrom(urlString: nowTVShow.poster_path!)
            
        } else {
            titleLabel.text = ""
            rateView.isHidden = true
            coverImageView.image = UIImage(named: "port-more")
        }
        
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = cornerRadius
        
        posterCoverView.dropShadow(radius: cornerRadius)
        
    }
    
}
