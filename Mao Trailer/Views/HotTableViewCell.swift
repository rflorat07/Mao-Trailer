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
    
    let movieCollectionDataSource = MovieCollectionDataSource()
    
    var hotMovies: SectionData!  {
        didSet{
            
            hotCollectionView.delegate = movieCollectionDataSource
            hotCollectionView.dataSource = movieCollectionDataSource
            
            movieCollectionDataSource.update(with: hotMovies)
            movieCollectionDataSource.didSelectAction = { (indexPath) in
                self.didSelectAction(indexPath)
            }
            
            hotCollectionView.reloadData()
        }
    }
    
    var didSelectAction: (IndexPath) -> Void = { arg in }
    
}

