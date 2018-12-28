//
//  ImageCollectionDataSource.swift
//  Mao Trailer
//
//  Created by Roger Florat on 28/12/2018.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class ImageCollectionDataSource: NSObject, UICollectionViewDataSource {
    
    var images: [Image]!
    
    var didSelectAction: (IndexPath) -> Void = { arg in }
    
    func update(with images: [Image]) {
        self.images = images
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return images != nil ? 1 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.detailImagesCollectionViewCell, for: indexPath) as! DetailImagesCollectionViewCell
        
        cell.backdropImage = images[indexPath.row]
        
        return cell
    }
    
}

extension ImageCollectionDataSource: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectAction(indexPath)
    }
}
