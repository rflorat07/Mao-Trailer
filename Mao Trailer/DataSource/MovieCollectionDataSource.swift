//
//  MovieCollectionDataSource.swift
//  Mao Trailer
//
//  Created by Roger Florat on 27/12/2018.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class MovieCollectionDataSource: NSObject, UICollectionViewDataSource  {
    
    var moviesSection: SectionData!
    var didSelectAction: (IndexPath) -> Void = { arg in }
    
    override init() {
        super.init()
    }
    
    func update(with section: SectionData) {
        self.moviesSection = section
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesSection.sectionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (moviesSection.sectionName == "Discover") {
            
            let   cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.hotViewCell, for: indexPath) as! HotCollectionViewCell
            
            cell.hotMovie = moviesSection.sectionArray[indexPath.row]
            
            return cell
            
            
        } else {
            
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.sectionViewCell, for: indexPath) as! SectionCollectionViewCell
            
            cell.sectionMovie = moviesSection.sectionArray[indexPath.row]
            
            return cell
        }
        
        
    }
    
}

extension MovieCollectionDataSource: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        didSelectAction(indexPath)
    }
}
