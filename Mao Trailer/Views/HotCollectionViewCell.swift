//
//  HotCollectionViewCell.swift
//  Mao Trailer
//
//  Created by Roger Florat on 19/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class HotCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!
    
    var hotMovie: Movie! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI(){
        
        let cornerRadius: CGFloat = 6
        
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = cornerRadius
        coverImageView.image = UIImage(named: hotMovie.imgUrl)
    
    }
    
}
