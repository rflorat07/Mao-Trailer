//
//  ProfileListCollectionViewCell.swift
//  Mao Trailer
//
//  Created by Roger Florat on 27/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class ProfileListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterView: UIView!
    @IBOutlet weak var coverImageView: UIImageView!
    
    var posterImage: String! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI() {
        
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = Constants.cornerRadius
        coverImageView.image = UIImage(named: posterImage)
    }
}
