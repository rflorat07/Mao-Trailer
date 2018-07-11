//
//  TVMovieListCollectionViewController.swift
//  Mao Trailer
//
//  Created by Roger Florat on 21/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class TVMovieListCollectionViewController: UICollectionViewController {
    
    var sectionData: SectionTVMovie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        insertRefreshControl()
    }
    
    func insertRefreshControl() {
        let refresh = UIRefreshControl()
        
        refresh.addTarget(self, action: #selector(self.refreshCollectionView), for: UIControlEvents.valueChanged)
        
        collectionView?.refreshControl = refresh
    }
    
    @objc func refreshCollectionView() {
        print("Refresh Collection View")
        collectionView?.refreshControl?.endRefreshing()
    }
        
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Storyboard.movieListReusableView, for: indexPath) as? MovieListSectionHeaderCollectionReusableView {
            
            sectionHeader.sectionTitleLabel.text = sectionData.sectionName
            
            return sectionHeader
        }
        
        return UICollectionReusableView()
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return sectionData.sectionArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.movieListViewCell, for: indexPath) as! MovieListCollectionViewCell
        
        cell.movie = sectionData.sectionArray[indexPath.row]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let tvMovieDetail = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.movieDetailViewController) as? TVMovieDetailViewController {
            
            tvMovieDetail.modalPresentationStyle = .overFullScreen
            tvMovieDetail.modalTransitionStyle = .crossDissolve
            
            tvMovieDetail.detail = sectionData.sectionArray[indexPath.row]
            
            self.present(tvMovieDetail, animated: true, completion: nil)
        }
        
    }
}
