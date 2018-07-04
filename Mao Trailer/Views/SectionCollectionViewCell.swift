//
//  SectionCollectionViewCell.swift
//  Mao Trailer
//
//  Created by Roger Florat on 20/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class SectionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterCoverView: UIView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var rateView: UIView!
    
    let cornerRadius: CGFloat = Constants.cornerRadius
    
    var sectionMovie: Movie! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI() {
        
        if sectionMovie.title != "More" {
            
            titleLabel.text = sectionMovie.title.uppercased()
            rateLabel.text = String(format:"%.1f", sectionMovie.vote_average)
            
        } else {
            titleLabel.text = ""
            rateView.isHidden = true
        }
        
        loadImage(withPath: sectionMovie)
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = cornerRadius
        
        posterCoverView.dropShadow(radius: cornerRadius)
    }
    
    func loadImage(withPath: Movie) {
        
        var downloadImage = UIImage()
        
        //Download Image
        let imageString = "https://image.tmdb.org/t/p/w500\(withPath.poster_path)"
        guard let imageUrl = URL(string: imageString) else { return }
        let imageProcessor = QueryService()
        imageProcessor.downloadImage(withPath: imageUrl) { (data, response, error) in
            
            DispatchQueue.main.async {
                guard let imageData = data else { return }
                downloadImage = UIImage(data: imageData)!
                self.coverImageView.image = downloadImage
            }
            
        }
    }
    
}








