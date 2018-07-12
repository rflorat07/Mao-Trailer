//
//  TVMovieListCollectionViewController.swift
//  Mao Trailer
//
//  Created by Roger Florat on 21/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class TVMovieListCollectionViewController: UICollectionViewController {
    
    var page = 2
    var fetchingMore = false
    var sectionData: SectionData!
    var queryService = QueryService.intance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func fetchMoreMovies() {
    
        self.collectionView?.performBatchUpdates({
            
            
         /*   queryService.fetchMovieList(page: page, listString: sectionData.sectionName, { (movieList) in
                
                let newMovieList: [TVFilm] = movieList!.getMovieList()
                self.sectionData.sectionArray.append(contentsOf: newMovieList)
                self.fetchingMore = false
                self.collectionView?.reloadData()
                
                (movieList?.page)! > self.page ? (self.page + 1) : self.page 
                
            }) */
            
        }, completion: nil)
    
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
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == self.sectionData.sectionArray.count - 1 && !fetchingMore {
            fetchingMore = true
            self.fetchMoreMovies()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let tvMovieDetail = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.movieDetailsViewController) as? TVMovieDetailsViewController {
            
            tvMovieDetail.modalPresentationStyle = .overFullScreen
            tvMovieDetail.modalTransitionStyle = .crossDissolve
            
            tvMovieDetail.information = sectionData.sectionArray[indexPath.row]
            
            self.present(tvMovieDetail, animated: true, completion: nil)
        }
        
    }
}
