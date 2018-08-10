//
//  DetailImagesCollectionViewCell.swift
//  Mao Trailer
//
//  Created by Roger Florat on 16/07/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit
import Kingfisher

class DetailImagesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var coverBackdropsView: UIView!
    @IBOutlet weak var coverImageView: UIImageView!
    
    let cornerRadius: CGFloat = Constants.cornerRadius
    
    var backdropImage: Image! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI() {
        
        let imagePath = Helpers.downloadedFrom(urlString: backdropImage.file_path!, size: ImageSize.large)
        
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = cornerRadius
        coverImageView.kf.setImage(with: URL(string: imagePath), placeholder: Constants.placeholderImage)
        
        coverBackdropsView.dropShadow(radius: cornerRadius)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        coverImageView.image = nil
    }
    
}
