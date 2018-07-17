//
//  DetailFullCastCollectionViewCell.swift
//  Mao Trailer
//
//  Created by Roger Florat on 26/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class DetailFullCastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var coverCastView: UIView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var creditLabel: UILabel!
    
    let cornerRadius: CGFloat = 3.0
    
    var cast: Cast! {
        didSet{
            updateUI()
        }
    }
    
    func updateUI() {
        
        nameLabel.text = cast.name
        creditLabel.text = cast.character
        
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = cornerRadius
        coverImageView.downloadedFrom(urlString: cast.profile_path!)
       
        coverCastView.dropShadow(radius: cornerRadius)
        
    }
    
}