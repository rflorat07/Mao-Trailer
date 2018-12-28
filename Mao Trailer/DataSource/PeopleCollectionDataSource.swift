//
//  PeopleCollectionDataSource.swift
//  Mao Trailer
//
//  Created by Roger Florat on 27/12/2018.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class PeopleCollectionDataSource: NSObject, UICollectionViewDataSource  {

    var moviesSection: [TVMovie]!
    var didSelectAction: (TVMovie) -> Void = { arg in }
    
    func update(with section: [TVMovie]) {
        self.moviesSection = section
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return moviesSection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.filmographyCollectionViewCell, for: indexPath) as! PersonDetailsInfoCollectionViewCell
        
        cell.filmography = moviesSection[indexPath.row]
        
        return cell
    }
    
}


extension PeopleCollectionDataSource: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        didSelectAction(moviesSection[indexPath.row])
    }
}
