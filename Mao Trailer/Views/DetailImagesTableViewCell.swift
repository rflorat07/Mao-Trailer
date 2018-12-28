//
//  DetailImagesTableViewCell.swift
//  Mao Trailer
//
//  Created by Roger Florat on 01/08/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class DetailImagesTableViewCell: UITableViewCell {

    @IBOutlet weak var detailImagesCollectionView: UICollectionView!
    
    let imageCollectionDataSource = ImageCollectionDataSource()
    
    var images: [Image]! {
        didSet{
            
            detailImagesCollectionView.delegate = imageCollectionDataSource
            detailImagesCollectionView.dataSource = imageCollectionDataSource
            
            imageCollectionDataSource.update(with: images)
            imageCollectionDataSource.didSelectAction = { (index) in
                self.didSelectAction(index)
            }
            
            detailImagesCollectionView.reloadData()
        }
    }
    
    var didSelectAction: (IndexPath) -> Void = { arg in }
    
}
