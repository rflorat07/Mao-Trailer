//
//  DetailCastTableViewCell.swift
//  Mao Trailer
//
//  Created by Roger Florat on 01/08/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class DetailCastTableViewCell: UITableViewCell {

    @IBOutlet weak var detailCastCollectionView: UICollectionView!
    
    let castCollectionDataSource = CastCollectionDataSource()
    
    
    var cast: [Cast]! {
        didSet{
            
            detailCastCollectionView.delegate = castCollectionDataSource
            detailCastCollectionView.dataSource = castCollectionDataSource
            
            castCollectionDataSource.update(with: cast)
            castCollectionDataSource.didSelectAction = { (cast) in
                self.didSelectAction(cast)
            }
            
            detailCastCollectionView.reloadData()
        }
    }
    
    var didSelectAction: (Cast) -> Void = { arg in }
    
}
