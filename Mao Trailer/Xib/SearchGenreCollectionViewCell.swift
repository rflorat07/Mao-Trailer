//
//  SearchGenreCollectionViewCell.swift
//  Mao Trailer
//
//  Created by Roger Florat on 25/07/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class SearchGenreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!

    var genre: Genre! {
        didSet{
            nameLabel.text = genre.name
        }
    }
    
}
