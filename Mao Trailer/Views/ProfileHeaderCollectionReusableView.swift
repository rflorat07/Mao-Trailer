//
//  ProfileHeaderCollectionReusableView.swift
//  Mao Trailer
//
//  Created by Roger Florat on 27/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit
import Kingfisher

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var watchingLabel: UILabel!
    @IBOutlet weak var ratingsLabel: UILabel!
    @IBOutlet weak var coverAvatarView: UIView!
    
    let cornerRadius: CGFloat = 55.0
    
    var didSelectAction: (String) -> Void = { arg in }
    
    var profile: AccountDetails! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI() {
        
        let imagePath = Helpers.downloadedAvatarFrom(urlString: profile.getImageAvatar())
        
        nameLabel.text = profile.name.uppercased()
        
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.borderWidth = 3
        avatarImageView.layer.cornerRadius = cornerRadius
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        avatarImageView.kf.setImage(with: URL(string: imagePath), placeholder: Constants.placeholderImage)
        
    }
    
    func changeActiveLabel(selected: UILabel) {
        
        self.favoritesLabel.textColor = Colors.subtitleColor
        self.watchingLabel.textColor = Colors.subtitleColor
        self.ratingsLabel.textColor = Colors.subtitleColor
        
        selected.textColor = Colors.rateColor
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        
        let active = sender.titleLabel?.text
        
        self.didSelectAction(active!)
        
        switch active {
            
            case "Favorites":
                changeActiveLabel(selected: self.favoritesLabel)
            
            case "Watching":
                changeActiveLabel(selected: self.watchingLabel)
            
            default:
                changeActiveLabel(selected: self.ratingsLabel)
        }
        
    }
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = ""
        avatarImageView.image = nil
    }
}
