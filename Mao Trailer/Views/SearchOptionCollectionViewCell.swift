//
//  SearchOptionCollectionViewCell.swift
//  Mao Trailer
//
//  Created by Roger Florat on 26/07/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class SearchOptionCollectionViewCell: UICollectionViewCell {
    
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
                
        titleLabel.text = searchTVMovie.title.uppercased()
        rateLabel.text = String(format:"%.1f", searchTVMovie.vote_average)
        
        coverImageView.clipsToBounds = true
        coverImageView.downloadedFrom(urlString: searchTVMovie.poster_path ?? searchTVMovie.backdrop_path!)
        coverImageView.layer.cornerRadius = cornerRadius
        
        posterCoverView.dropShadow(radius: cornerRadius)
    }
    
    override func prepareForReuse() {
        titleLabel.text = ""
        rateLabel.text = "0.0"
        coverImageView.image = nil
    }
}
