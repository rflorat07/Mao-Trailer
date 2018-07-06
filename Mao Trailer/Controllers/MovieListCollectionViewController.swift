//
//  MovieListCollectionViewController.swift
//  Mao Trailer
//
//  Created by Roger Florat on 21/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class MovieListCollectionViewController: UICollectionViewController {
    
    var movieList: SectionMovie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
        
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Storyboard.movieListReusableView, for: indexPath) as? MovieListSectionHeaderCollectionReusableView {
            
            sectionHeader.sectionTitleLabel.text = movieList.sectionName
            
            return sectionHeader
        }
        
        return UICollectionReusableView()
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return movieList.movieArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.movieListViewCell, for: indexPath) as! MovieListCollectionViewCell
        
        cell.movie = movieList.movieArray[indexPath.row]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let movieDetail = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.movieDetailViewController) as? MovieDetailViewController {
            
            movieDetail.modalPresentationStyle = .overFullScreen
            movieDetail.modalTransitionStyle = .crossDissolve
            
            movieDetail.movie = movieList.movieArray[indexPath.row]
            
            self.present(movieDetail, animated: true, completion: nil)
        }
        
    }
}
