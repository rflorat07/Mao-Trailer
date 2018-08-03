//
//  PersonDetailsInfoCollectionViewCell.swift
//  Mao Trailer
//
//  Created by Roger Florat on 31/07/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class PersonDetailsInfoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var coverImageView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    let cornerRadius: CGFloat = Constants.cornerRadius
    
    var filmography: TVMovie! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI(){
        
        titleLabel.text = filmography.title.uppercased()
                
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = Constants.cornerRadius
        posterImageView.downloadedFrom(urlString: filmography.poster_path ?? filmography.backdrop_path!)
        
        coverImageView.dropShadow(radius: Constants.cornerRadius)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = ""
        posterImageView.image = nil
    }
    
}
