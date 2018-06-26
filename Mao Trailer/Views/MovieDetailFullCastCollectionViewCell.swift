//
//  MovieDetailFullCastCollectionViewCell.swift
//  Mao Trailer
//
//  Created by Roger Florat on 26/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class MovieDetailFullCastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var creditLabel: UILabel!
    
    var cast: Cast! {
        didSet{
            updateUI()
        }
    }
    
    func updateUI() {
        
        nameLabel.text = cast.name
        creditLabel.text = cast.character
        
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = 3.0
        coverImageView.image = UIImage(named: cast.imgUrl)
        
    }
    
}
