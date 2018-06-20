//
//  SectionTableViewCell.swift
//  Mao Trailer
//
//  Created by Roger Florat on 20/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class SectionTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var sectionCollectionView: UICollectionView!
    
    var imageArray = [String] ()
    var titleArray = [String] ()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        sectionCollectionView.delegate = self
        sectionCollectionView.dataSource = self
        
        imageArray = ["TombRaider-Slide", "SpiderMan-Slide", "Arrival-Slide", "Narcos-Slide"]
        
        titleArray = ["Tomb Raider", "Spider-Man: Homecoming", "Arrival", "Narcos" ]
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionViewCell", for: indexPath) as! SectionCollectionViewCell
        
        cell.titleLabel.text = titleArray[indexPath.row].uppercased()
        cell.coverImageView.image = UIImage(named: imageArray[indexPath.row])
        
        return cell
        
    }
  
}
