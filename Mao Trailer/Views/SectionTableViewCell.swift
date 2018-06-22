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
    
    var imageArray = [String]()
    var titleArray = [String]()
    var sectionMovies = [Movie]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        sectionCollectionView.delegate = self
        sectionCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.sectionViewCell, for: indexPath) as! SectionCollectionViewCell
        
        cell.sectionMovie = sectionMovies[indexPath.row]
        
        return cell
        
    }
  
}
