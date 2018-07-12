//
//  SearchListCollectionViewController.swift
//  Mao Trailer
//
//  Created by Roger Florat on 09/07/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class SearchListCollectionViewController: UICollectionViewController, UISearchBarDelegate {
    
    var itemList = [TVMovie]()
    let searchBar = UISearchBar()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createSearchBar()

    }
    
    func createSearchBar() {
       
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Enter you search here!"
        
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
    }
    
     // MARK: Search 
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       
        searchBar.endEditing(true)
        
      /*  QueryServiceMovie.intance.searchMovieFromWord(searchText: searchBar.text!) { (movieList) in
            if let movieList = movieList {
                self.itemList = movieList.getMovieList()
                self.collectionView?.reloadData()
            }
        } */
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }

    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return itemList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.searchListViewCell, for: indexPath) as! SearchListCollectionViewCell
    
        cell.searchTVMovie = itemList[indexPath.row]
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let tvMovieDetail = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.movieDetailsViewController) as? TVMovieDetailsViewController {
            
            tvMovieDetail.modalPresentationStyle = .overFullScreen
            tvMovieDetail.modalTransitionStyle = .crossDissolve
            
            tvMovieDetail.information = itemList[indexPath.row]
            
            self.present(tvMovieDetail, animated: true, completion: nil)
        }
        
    }

}
