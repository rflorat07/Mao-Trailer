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
    
    var tvShows: Movie! {
        didSet{
            self.updateUI()
        }
    }
    
    func updateUI() {
        
        if tvShows.title != "More" {
            
            titleLabel.text = tvShows.title.uppercased()
            rateLabel.text = String(format: "%.1f", tvShows.vote_average)
            
        } else {
            
            titleLabel.text = ""
            rateView.isHidden = true
        }
        
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = cornerRadius
        coverImageView.image = UIImage(named: tvShows.poster_path)
        
        posterCoverView.dropShadow(radius: cornerRadius)
    }
    
}
