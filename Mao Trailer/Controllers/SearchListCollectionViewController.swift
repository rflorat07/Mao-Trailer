//
//  SearchListCollectionViewController.swift
//  Mao Trailer
//
//  Created by Roger Florat on 09/07/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class SearchListCollectionViewController: UICollectionViewController {
    
    var genreInfo: Int!
    var searchText: String = ""
    var fetchingMore: Bool = false
    
    var queryType: MediaType!
    var searchData: SectionData!
    var officialGenres: [Genre] = [Genre]()
    var officialGenresTemp: [Genre] = [Genre]()
    
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createSearchBar()
        self.loadOfficialGenres()
        
        self.collectionView?.register(UINib(nibName: "SearchGenreCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Storyboard.searchGenreViewCell)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segue.toSearchOption {
            
            let toViewController = segue.destination as! SearchOptionCollectionViewController
            
            toViewController.queryType = queryType
            toViewController.genreInfo = sender as? Genre
        }
        
        if segue.identifier == Segue.toSearchDetail {
            
            let navigationContoller = segue.destination as! UINavigationController
            
            let receiverViewController = navigationContoller.topViewController as! TVMovieDetailsViewController
            
            receiverViewController.queryType = queryType
            
            switch queryType.rawValue {
            case "movie":
                receiverViewController.information = sender as? Movie
            default:
                receiverViewController.information = sender as? TVShow
            }
        }
    }
    
    // MARK: Official Genres
    func loadOfficialGenres() {
        
        LoadingIndicatorView.show("Loading")
        
        QueryService.instance.fetchOfficialGenres(type: queryType) { (genreArray) in
            if let genreArray = genreArray {
                self.officialGenres = genreArray.genres
                self.officialGenresTemp = genreArray.genres
                
                LoadingIndicatorView.hide()
                
                self.collectionView?.reloadData()
            }
        }
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    // MARK: Search With Text
    
    func searchMovieOrTVShowWithText(searchText: String, page: Int? = 1, type: MediaType) {
        
        self.fetchingMore = true
        
        QueryService.instance.search(searchText: searchText, page: page!, type: type) { (sectionData) in
            
            if let sectionData = sectionData {
                
                self.searchData.page = sectionData.page
                self.searchData.total_pages = sectionData.total_pages
                self.searchData.sectionName = sectionData.sectionName
                self.searchData.sectionArray.append(contentsOf: sectionData.getSectionArray())
                
                self.fetchingMore = false
                
                self.collectionView?.reloadData()
            }
        }
    }
    
    // MARK: Discover more Movie or TVShow
    
    func discoverMoreMovieOrTVShow(page: Int? = 1, type: MediaType, genre: Int) {
        
        self.fetchingMore = true
        
        QueryService.instance.fetchDiscoverSectioByGenres(type: queryType, genre: genre, page: page!) { (sectionData) in
            
            if let sectionData = sectionData {
                
                self.searchData.page = sectionData.page
                self.searchData.total_pages = sectionData.total_pages
                self.searchData.sectionName = sectionData.sectionName
                self.searchData.sectionArray.append(contentsOf: sectionData.getSectionArray())
                
                self.fetchingMore = false
                
                self.collectionView?.reloadData()
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return section == 0 ? officialGenres.count : searchData.sectionArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.searchGenreViewCell, for: indexPath) as! SearchGenreCollectionViewCell
            
            cell.genre = self.officialGenres[indexPath.row]
            
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.searchListViewCell, for: indexPath) as! SearchListCollectionViewCell
            
            let searchArray = searchData.sectionArray
            
            cell.searchTVMovie = searchArray[indexPath.row]
            
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == searchData.sectionArray.count - 1 && searchData.page < searchData.total_pages && !fetchingMore {
            
            if genreInfo != nil {
                discoverMoreMovieOrTVShow(page: searchData.page + 1, type: queryType, genre: genreInfo)
            } else {
                searchMovieOrTVShowWithText(searchText: searchText, page: searchData.page + 1 , type: queryType)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            let gendeInfo = officialGenresTemp[indexPath.row]
            
            self.performSegue(withIdentifier: Segue.toSearchOption, sender: gendeInfo)
            
        } else {
            let selected = searchData.sectionArray[indexPath.row]
            
            self.performSegue(withIdentifier: Segue.toSearchDetail, sender: selected)
        }
    }
}

// MARK: UISearchBarDelegate

extension SearchListCollectionViewController: UISearchBarDelegate {
    
    func createSearchBar() {
        
        searchBar.delegate = self
        
        searchBar.sizeToFit()
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Enter you search here!"
        searchBar.tintColor = Colors.headerColor
  
        //searchBar.becomeFirstResponder()
        
        if let searchTextField = searchBar.value(forKey: "_searchField") as? UITextField {
            searchTextField.backgroundColor = Colors.backgroundColor
        }
        
        self.navigationItem.titleView = searchBar
        self.navigationItem.hidesBackButton = true
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            self.searchData = SectionData()
            self.officialGenres = officialGenresTemp
            self.collectionView?.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.endEditing(true)
        self.officialGenres = [Genre]()
        self.searchData = SectionData()
        self.searchText = searchBar.text!
        self.searchMovieOrTVShowWithText(searchText: searchText, type: queryType)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        if let navController = self.navigationController {
            navController.popViewController(animated: false)
        }
    }
    
}

// MARK: UICollectionViewDelegateFlowLayout

extension SearchListCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let topEdgeInsets = section == 0 ? 10 : 0
        
        return UIEdgeInsets(top: CGFloat(topEdgeInsets), left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return section == 0 ? 15 : 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            return CGSize(width: collectionView.frame.width - 40, height: 30.0)
        } else {
            return CGSize(width: (collectionView.frame.width / 2) - 30, height: 283.0)
        }
    }
    
    
}
