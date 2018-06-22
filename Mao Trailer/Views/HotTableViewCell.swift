//
//  HotTableViewCell.swift
//  Mao Trailer
//
//  Created by Roger Florat on 19/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class HotTableViewCell: UITableViewCell {
    
    @IBOutlet weak var hotCollectionView: UICollectionView!
    
    var hotMovies = [Movie] ()
    var didSelectAction: () -> Void = {}
 
    override func awakeFromNib() {
        super.awakeFromNib()
        
        hotCollectionView.delegate = self
        hotCollectionView.dataSource = self
    }
}

extension HotTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hotMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.hotViewCell, for: indexPath) as! HotCollectionViewCell
        
        cell.hotMovie = hotMovies[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          didSelectAction()
    }
    
}