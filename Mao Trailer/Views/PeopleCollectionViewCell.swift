//
//  PeopleCollectionViewCell.swift
//  Mao Trailer
//
//  Created by Roger Florat on 03/08/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit
import Kingfisher

class PeopleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var coverImageView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    
    let cornerRadius: CGFloat = Constants.cornerRadius
    
    var people: Popular!{
        didSet{
            self.updateUI()
        }
    }
    
    func updateUI() {
        
        let imagePath = Helpers.downloadedFrom(urlString: people.profile_path ?? "")
        
        nameLabel.text = people.name.uppercased()
        
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = cornerRadius
        profileImageView.kf.setImage(with: URL(string: imagePath), placeholder: Constants.placeholderImage)
        
        coverImageView.dropShadow(radius: cornerRadius)
    }
}
