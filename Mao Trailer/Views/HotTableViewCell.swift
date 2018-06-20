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
 
    override func awakeFromNib() {
        super.awakeFromNib()
        
        hotCollectionView.delegate = self
        hotCollectionView.dataSource = self
        
        imageArray = ["HotView-Slide", "TopView-Slide", "TVPopular-Slide", "HotFlash-Slide"]
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotViewCell", for: indexPath) as! HotCollectionViewCell
        
        cell.coverImageView.image = UIImage(named: imageArray[indexPath.row])
        
        return cell
        
    }
    
}
