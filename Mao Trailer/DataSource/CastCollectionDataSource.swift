//
//  CastCollectionDataSource.swift
//  Mao Trailer
//
//  Created by Roger Florat on 28/12/2018.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class CastCollectionDataSource: NSObject, UICollectionViewDataSource {
    
    var cast: [Cast]!
    var didSelectAction: (Cast) -> Void = { arg in }
    
    func update(with cast: [Cast]) {
        self.cast = cast
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return cast != nil ? 1 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.detailCastCollectionViewCell, for: indexPath) as! DetailCastCollectionViewCell
        
        cell.cast = cast[indexPath.row]
        
        return cell
    }
    
    
}

extension CastCollectionDataSource: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        didSelectAction(self.cast[indexPath.row])
    }
}
