//
//  PersonDetailsInfoTableViewCell.swift
//  Mao Trailer
//
//  Created by Roger Florat on 31/07/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class PersonDetailsInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var filmographyCollectionView: UICollectionView!
    
    let peopleCollectionDataSource = PeopleCollectionDataSource()
    
    var filmography: [TVMovie]! {
        
        didSet{
            
            filmographyCollectionView.delegate = peopleCollectionDataSource
            filmographyCollectionView.dataSource = peopleCollectionDataSource
            
            peopleCollectionDataSource.update(with: filmography)
            peopleCollectionDataSource.didSelectAction = { (movie) in
                self.didSelectAction(movie)
            }
            
            filmographyCollectionView.reloadData()
        }
    }
    
    var didSelectAction: (TVMovie) -> Void = { arg in }
    
    
}

