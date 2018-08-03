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
    
    var cast: [Cast]! {
        didSet{
            detailCastCollectionView.reloadData()
        }
    }
    
    var didSelectAction: (Cast) -> Void = { arg in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        detailCastCollectionView.delegate = self
        detailCastCollectionView.dataSource = self
    }
}

extension DetailCastTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return cast != nil ? 1 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.detailCastCollectionViewCell, for: indexPath) as! DetailCastCollectionViewCell
        
        cell.cast = cast[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectAction(self.cast[indexPath.row])
    }
}
