//
//  DetailImagesCollectionViewCell.swift
//  Mao Trailer
//
//  Created by Roger Florat on 16/07/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

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
        
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = cornerRadius
        coverImageView.downloadedFrom(urlString: backdropImage.file_path!, size: ImageSize.large)
        
        coverBackdropsView.dropShadow(radius: cornerRadius)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        coverImageView.image = nil
    }
    
}
