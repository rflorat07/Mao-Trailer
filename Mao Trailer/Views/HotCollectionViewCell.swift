//
//  HotCollectionViewCell.swift
//  Mao Trailer
//
//  Created by Roger Florat on 19/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class HotCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var posterCoverView: UIView!
    @IBOutlet weak var coverImageView: UIImageView!
    
    let cornerRadius: CGFloat = Constants.cornerRadius
    
    var hotMovie: Movie! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI(){
        
        loadImage(withPath: hotMovie)
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = Constants.cornerRadius
        
        posterCoverView.dropShadow(radius: Constants.cornerRadius)
    }
    
    func loadImage(withPath: Movie) {
        
        var downloadImage = UIImage()
        
        //Download Image
        let imageString = "https://image.tmdb.org/t/p/w500\(withPath.backdrop_path)"
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
