//
//  ImagePreviewCollectionViewCell.swift
//  Mao Trailer
//
//  Created by Roger Florat on 17/07/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class ImagePreviewCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var image: Image! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI() {
        imageView.downloadedFrom(urlString: image.file_path!, contentMode: .scaleAspectFit, size: ImageSize.large)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
}
