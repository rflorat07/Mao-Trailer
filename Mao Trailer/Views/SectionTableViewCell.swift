//
//  SectionTableViewCell.swift
//  Mao Trailer
//
//  Created by Roger Florat on 20/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class SectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var sectionCollectionView: UICollectionView!

    var sectionMovies: SectionData! {
        didSet{
            sectionMovieArray = sectionMovies.sectionArray
            sectionTitleLabel.text = sectionMovies.sectionName
            
            sectionCollectionView.reloadData()
        }
    }
 
    var sectionMovieArray: [TVMovie] = [TVMovie]()
    var didSelectAction: (IndexPath) -> Void = { arg in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
      sectionCollectionView.delegate = self
      sectionCollectionView.dataSource = self
    }
}

extension SectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionMovieArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.sectionViewCell, for: indexPath) as! SectionCollectionViewCell
        
        cell.sectionMovie = sectionMovieArray[indexPath.row]
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectAction(indexPath)
    }
}
