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
    
    let movieCollectionDataSource = MovieCollectionDataSource()
    
    var sectionMovies: SectionData! {
        
        didSet{
            sectionTitleLabel.text = sectionMovies.sectionName
            
            sectionCollectionView.delegate = movieCollectionDataSource
            sectionCollectionView.dataSource = movieCollectionDataSource
            
            movieCollectionDataSource.update(with: sectionMovies)
            movieCollectionDataSource.didSelectAction = { (indexPath) in
                self.didSelectAction(indexPath)
            }
            
            
            sectionCollectionView.reloadData()
        }
    }
    
    var didSelectAction: (IndexPath) -> Void = { arg in }
    
}
