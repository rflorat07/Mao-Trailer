//
//  SectionCollectionViewCell.swift
//  Mao Trailer
//
//  Created by Roger Florat on 20/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class SectionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coverView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.configure()
    }
    
    func configure(){
        
        let cornerRadius: CGFloat = 6
        
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = cornerRadius
        
       /* coverView.layer.shadowRadius = 5
        coverView.layer.shadowOpacity = 1
        coverView.layer.masksToBounds = false
        coverView.layer.shadowColor = UIColor.black.cgColor
        coverView.layer.shadowOffset = CGSize(width: 0, height: 3.0) */
        
        

    }
}
