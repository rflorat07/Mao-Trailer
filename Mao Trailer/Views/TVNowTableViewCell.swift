//
//  TVNowTableViewCell.swift
//  Mao Trailer
//
//  Created by Roger Florat on 21/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class TVNowTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nowCollectionView: UICollectionView!
    
    let tvCollectionDataSource = TVCollectionDataSource()
    
    var nowTVShows: SectionData! {
        didSet{
            
            nowCollectionView.delegate = tvCollectionDataSource
            nowCollectionView.dataSource = tvCollectionDataSource
            
            tvCollectionDataSource.update(with: nowTVShows)
            tvCollectionDataSource.didSelectAction = { (indexPath) in
                self.didSelectAction(indexPath)
            }
            
            nowCollectionView.reloadData()
        }
    }
    
    var didSelectAction: (IndexPath) -> Void = { arg in }
    
}
