//
//  HotTableViewCell.swift
//  Mao Trailer
//
//  Created by Roger Florat on 19/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class HotTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var hotCollectionView: UICollectionView!
    
    var imageArray = [String] ()
    var hotMovies = [Movie] ()
 
    override func awakeFromNib() {
        super.awakeFromNib()
        
        hotCollectionView.delegate = self
        hotCollectionView.dataSource = self
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hotMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotViewCell", for: indexPath) as! HotCollectionViewCell
        
        cell.hotMovie = hotMovies[indexPath.row]
        
        return cell
        
    }
    
}
