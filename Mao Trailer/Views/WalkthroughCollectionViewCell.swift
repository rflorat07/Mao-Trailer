//
//  WalkthroughCollectionViewCell.swift
//  Mao Trailer
//
//  Created by Roger Florat on 29/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class WalkthroughCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var nextButtonView: UIView!
    @IBOutlet weak var getStaredButton: UIButton!
    @IBOutlet weak var getStaredButtonView: UIView!
    
    let cornerRadius: CGFloat = 25.0

    var walkthroughData: Walkthrough! {
        didSet {
            self.updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.nextButton.layer.borderWidth = 2.0
        self.nextButton.layer.cornerRadius = cornerRadius
        self.nextButton.layer.borderColor = UIColor.white.cgColor
        
        self.getStaredButton.clipsToBounds = true
        self.getStaredButton.layer.cornerRadius = cornerRadius
    }
    
    func updateUI() {
        
        titleLabel.text = walkthroughData.title
        infoLabel.text = walkthroughData.description
        imageView.image = UIImage(named: walkthroughData.imgUrl)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        infoLabel.text = nil
        titleLabel.text = nil
        imageView.image = nil
    }
    
}
