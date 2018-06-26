//
//  MovieListCollectionViewController.swift
//  Mao Trailer
//
//  Created by Roger Florat on 21/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class MovieListCollectionViewController: UICollectionViewController {
    
    var movieList: Section!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segue.toMovieDetail {
            
            let toViewController = segue.destination as! MovieDetailTableViewController
            
            toViewController.movie = sender as! Movie
            
        }
    }

    // MARK: UICollectionViewDataSource
    
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
        
        return movieList.movieArray.count - 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.movieListViewCell, for: indexPath) as! MovieListCollectionViewCell
    
         cell.movie = movieList.movieArray[indexPath.row]
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: Segue.toMovieDetail, sender: movieList.movieArray[indexPath.row])
    }
}
