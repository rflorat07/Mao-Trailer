//
//  TVPopularTableViewCell.swift
//  Mao Trailer
//
//  Created by Roger Florat on 21/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class TVPopularTableViewCell: UITableViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var rateView: UIView!
    @IBOutlet weak var posterCoverView: UIView!
    
    let cornerRadius: CGFloat = Constants.cornerRadius
    
    var tvShow: TVShow! {
        didSet{
            self.updateUI()
        }
    }
    
    func updateUI() {
        
        if tvShow.title != "More" {
            
            titleLabel.text = tvShow.title.uppercased()
            rateLabel.text = String(format: "%.1f", tvShow.vote_average)
            coverImageView.downloadedFrom(urlString: tvShow.backdrop_path!)
            
        } else {
            
            titleLabel.text = ""
            rateView.isHidden = true
            coverImageView.image = UIImage(named: "land-more")
        }
        
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = cornerRadius

     
        posterCoverView.dropShadow(radius: cornerRadius)
    }
    
    override func prepareForReuse() {
        coverImageView.image = nil
    }
    
}
