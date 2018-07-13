//
//  SearchListCollectionViewCell.swift
//  Mao Trailer
//
//  Created by Roger Florat on 09/07/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class SearchListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterCoverView: UIView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var rateView: UIView!
    
    let cornerRadius: CGFloat = Constants.cornerRadius
    
    var searchTVMovie: TVMovie! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI() {
        
        if searchTVMovie.title != "More" {
            
            titleLabel.text = searchTVMovie.title.uppercased()
            coverImageView.downloadedFrom(urlString: searchTVMovie.poster_path ?? "placeholder")
            rateLabel.text = String(format:"%.1f", searchTVMovie.vote_average)
            
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
