//
//  TVNowTableViewCell.swift
//  Mao Trailer
//
//  Created by Roger Florat on 21/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class TVNowTableViewCell: UITableViewCell,UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var nowCollectionView: UICollectionView!
    
    var nowTVShows: [TVShow]! {
        didSet{
            nowCollectionView.reloadData()
        }
    }
    
    var didSelectAction: (TVShow) -> Void = { arg in }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nowCollectionView.delegate = self
        nowCollectionView.dataSource = self
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return nowTVShows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.tvNowViewCell, for: indexPath) as! TVNowCollectionViewCell
        
        cell.nowTVShow = nowTVShows[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        didSelectAction(nowTVShows[indexPath.row])
    }

}
