//
//  SearchListCollectionViewController.swift
//  Mao Trailer
//
//  Created by Roger Florat on 09/07/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class SearchListCollectionViewController: UICollectionViewController, UISearchBarDelegate {
    
    var searchText: String = ""
    var fetchingMore: Bool = false
    var queryType: MediaType!
    var searchData: SectionData!
    
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createSearchBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       self.changeNavigationBarColor(whiteColor: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.changeNavigationBarColor(whiteColor: true)
    }
    
    // MARK: Create SearchBar
    
    func createSearchBar() {
        
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        searchBar.showsCancelButton = true
        searchBar.placeholder = "Enter you search here!"
        
        self.navigationItem.titleView = searchBar
        self.navigationItem.hidesBackButton = true
        
        self.changeNavigationBarColor(whiteColor: false)
    }
    
    // MARK: Search
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.endEditing(true)
        self.searchData = SectionData()
        self.searchText = searchBar.text!
        self.searchMovieOrTVShowWithText(searchText: searchText, type: queryType)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        if let navController = self.navigationController {
            navController.popViewController(animated: false)
        }
    }
    
    func changeNavigationBarColor(whiteColor: Bool) {
        
        if whiteColor {
            
         self.navigationController?.navigationBar.barTintColor = UIColor.white
            
        } else  {
            
            self.navigationController?.navigationBar.barTintColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        }
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    // MARK: Search Text
    
    func searchMovieOrTVShowWithText(searchText: String, page: Int? = 1, type: MediaType) {
        
        self.fetchingMore = true
        
        QueryService.instance.search(searchText: searchText, page: page!, type: type) { (sectionData) in
            
            if let sectionData = sectionData {
                
                self.searchData.page = sectionData.page
                self.searchData.total_pages = sectionData.total_pages
                self.searchData.sectionName = sectionData.sectionName
                
                // Remove More Item
                if self.searchData.sectionArray.count > 10 {
                   self.searchData.sectionArray.removeLast()
                }
                
                self.searchData.sectionArray.append(contentsOf: sectionData.getSectionArray())
                
                self.fetchingMore = false
                
                self.collectionView?.reloadData()
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchData.sectionArray.count
    }
   
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.searchListViewCell, for: indexPath) as! SearchListCollectionViewCell
        
        let searchArray = searchData.sectionArray
        
        cell.searchTVMovie = searchArray[indexPath.row]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == searchData.sectionArray.count - 1 && searchData.page < searchData.total_pages && !fetchingMore {
            
            searchMovieOrTVShowWithText(searchText: searchText, page: searchData.page + 1 , type: queryType)
            
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let tvMovieDetail = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.movieDetailsViewController) as? TVMovieDetailsViewController {
            
            tvMovieDetail.modalPresentationStyle = .overFullScreen
            tvMovieDetail.modalTransitionStyle = .crossDissolve
            
            tvMovieDetail.queryType = queryType
            tvMovieDetail.information = self.searchData.sectionArray[indexPath.row]
            
            self.present(tvMovieDetail, animated: true, completion: nil)
        }
    }
    
}
