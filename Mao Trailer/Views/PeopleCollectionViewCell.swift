//
//  PeopleCollectionViewCell.swift
//  Mao Trailer
//
//  Created by Roger Florat on 03/08/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

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
        
        nameLabel.text = people.name.uppercased()
        
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = cornerRadius
        profileImageView.downloadedFrom(urlString: people.profile_path ?? "placeholder")
        
        coverImageView.dropShadow(radius: cornerRadius)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = ""
        profileImageView.image = nil
    }
    
}
