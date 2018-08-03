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
    
    var images: [Image]! {
        didSet{
            detailImagesCollectionView.reloadData()
        }
    }
    
    var didSelectAction: (IndexPath) -> Void = { arg in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        detailImagesCollectionView.delegate = self
        detailImagesCollectionView.dataSource = self
    }
}

extension DetailImagesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return images != nil ? 1 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.detailImagesCollectionViewCell, for: indexPath) as! DetailImagesCollectionViewCell
        
        cell.backdropImage = images[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectAction(indexPath)
    }
}
