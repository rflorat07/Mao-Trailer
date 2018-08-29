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
    @IBOutlet weak var favoritesView: UIView!
    @IBOutlet weak var watchingView: UIView!
    @IBOutlet weak var ratingsView: UIView!
    
    let cornerRadius: CGFloat = 55.0
    
    var didSelectAction: (String) -> Void = { arg in }
    
    var profile: AccountDetails! {
        didSet {
            self.updateUI()
        }
    }
    
    var activeLabel: String! {
        didSet {
            self.changeLabel(active: activeLabel)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.text = ""
        
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.borderWidth = 3
        avatarImageView.layer.cornerRadius = cornerRadius
        avatarImageView.layer.borderColor = UIColor.white.cgColor
    }
    
    func updateUI() {
        
        let imagePath = Helpers.downloadedAvatarFrom(urlString: profile.getImageAvatar())
        
        nameLabel.text = profile.name.uppercased()
        
        avatarImageView.kf.setImage(with: URL(string: imagePath), placeholder: Constants.placeholderImage)
    }
    
    func changeActiveLabel(selected: UILabel, cover: UIView) {
        
        self.favoritesLabel.textColor = Colors.subtitleColor
        self.watchingLabel.textColor = Colors.subtitleColor
        self.ratingsLabel.textColor = Colors.subtitleColor
        
        self.favoritesView.layer.shadowOpacity = 0.0
        self.watchingView.layer.shadowOpacity = 0.0
        self.ratingsView.layer.shadowOpacity = 0.0
        
        selected.textColor = Colors.rateColor
        cover.dropShadow(radius: Constants.cornerRadius)
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        
        let active = sender.titleLabel?.text
        
        self.didSelectAction(active!)
        self.changeLabel(active: active!)

    }
    
    
    func changeLabel(active: String) {
        
        switch active {
            
        case "Favorites":
            changeActiveLabel(selected: self.favoritesLabel, cover: self.favoritesView)
            
        case "Watching":
            changeActiveLabel(selected: self.watchingLabel, cover: self.watchingView)
            
        default:
            changeActiveLabel(selected: self.ratingsLabel, cover: self.ratingsView)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = ""
        avatarImageView.image = nil
    }
}
