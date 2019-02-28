//
//  CollectionViewGridLayout.swift
//  Mao Trailer
//
//  Created by Roger Florat on 02/01/2019.
//  Copyright © 2019 Roger Florat. All rights reserved.
//

import UIKit

class CollectionViewGridLayout: UICollectionViewFlowLayout
{
    var numberOfItemsPerRow: Int = 2 {
        didSet {
            invalidateLayout()
        }
    }
    
    override func prepare() {
        super.prepare()
        
        if let collectionView = self.collectionView {
            
            var newItemSize = itemSize
            let itemsPerRow = CGFloat(max(numberOfItemsPerRow, 1))
            let totalSpacing = minimumInteritemSpacing * (itemsPerRow - 1) + sectionInset.left + sectionInset.right
            newItemSize.width = (collectionView.bounds.size.width - totalSpacing) / itemsPerRow
            
            if itemSize.height > 0 {
                let itemAspectRatio = itemSize.width / itemSize.height
                newItemSize.height = newItemSize.width / itemAspectRatio
            }
            
            itemSize = newItemSize
        }
    }
}
