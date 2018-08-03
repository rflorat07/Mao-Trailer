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
    
    var filmography: [TVMovie]! {
        didSet{
            filmographyCollectionView.reloadData()
        }
    }
    
    var didSelectAction: (TVMovie) -> Void = { arg in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        filmographyCollectionView.delegate = self
        filmographyCollectionView.dataSource = self
    }
}

extension PersonDetailsInfoTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
        return filmography.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.filmographyCollectionViewCell, for: indexPath) as! PersonDetailsInfoCollectionViewCell
        
        cell.filmography = filmography[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectAction(filmography[indexPath.row])
    }
    
}
