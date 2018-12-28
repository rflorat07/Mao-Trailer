//
//  TVCollectionDataSource.swift
//  Mao Trailer
//
//  Created by Roger Florat on 27/12/2018.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class TVCollectionDataSource: NSObject, UICollectionViewDataSource  {
    
    var tvSection: SectionData!
    var didSelectAction: (IndexPath) -> Void = { arg in }
    
    func update(with section: SectionData) {
        self.tvSection = section
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return tvSection.sectionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.tvNowViewCell, for: indexPath) as! TVNowCollectionViewCell
        
        cell.nowTVShow = tvSection.sectionArray[indexPath.row]
        
        return cell
    }
}

extension TVCollectionDataSource: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        didSelectAction(indexPath)
    }
}
