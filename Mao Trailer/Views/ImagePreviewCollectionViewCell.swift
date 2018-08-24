//
//  ImagePreviewCollectionViewCell.swift
//  Mao Trailer
//
//  Created by Roger Florat on 17/07/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit
import Kingfisher

class ImagePreviewCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var image: Image! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI() {
        
        let imagePath = Helpers.downloadedFrom(urlString: image.file_path!, size: ImageSize.large)
        
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: URL(string: imagePath))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
}
