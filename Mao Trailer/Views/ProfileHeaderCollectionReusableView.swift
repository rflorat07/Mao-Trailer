//
//  ProfileHeaderCollectionReusableView.swift
//  Mao Trailer
//
//  Created by Roger Florat on 27/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var watchingLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var coverAvatarView: UIView!
    
    let cornerRadius: CGFloat = 55.0
    
    var avatarImage: String! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI() {
        
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = cornerRadius
        avatarImageView.image = UIImage(named: avatarImage)

    }
}
