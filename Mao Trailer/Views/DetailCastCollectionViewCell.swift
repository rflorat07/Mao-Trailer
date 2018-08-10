//
//  DetailCastCollectionViewCell.swift
//  Mao Trailer
//
//  Created by Roger Florat on 26/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit
import Kingfisher

class DetailCastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var coverCastView: UIView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var creditLabel: UILabel!
    
    let cornerRadius: CGFloat = 3.0
    
    var cast: Cast! {
        didSet{
            updateUI()
        }
    }
    
    func updateUI() {
        
        let imagePath = Helpers.downloadedFrom(urlString: cast.profile_path!)
        
        nameLabel.text = cast.name
        creditLabel.text = cast.character
        
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = cornerRadius
        coverImageView.kf.setImage(with: URL(string: imagePath), placeholder: Constants.placeholderImage)
       
        coverCastView.dropShadow(radius: cornerRadius)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = ""
        creditLabel.text = ""
        coverImageView.image = nil
    }
    
}
