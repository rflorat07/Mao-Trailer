//
//  SearchOptionCollectionViewController.swift
//  Mao Trailer
//
//  Created by Roger Florat on 26/07/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class SearchOptionCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var fetchingMore: Bool = false
    
    var genreInfo: Genre!
    var queryType: APIRequest!
    var searchData: SectionData = SectionData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadTheInitialData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        if segue.identifier == Segue.fromSearchOptionToDetail {
            
            let navigationContoller = segue.destination as! UINavigationController
            
            let receiverViewController = navigationContoller.topViewController as! DetailsTableViewController
            
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
    func loadTheInitialData() {
        
        self.title = genreInfo.name
        
        LoadingIndicatorView.show("Loading")
        
        self.discoverMoreMovieOrTVShow(type: queryType, genre: genreInfo.id, completion: { _ in
            
            LoadingIndicatorView.hide()
        })
    }
    
    
    
    // MARK: Discover more Movie or TVShow
    func discoverMoreMovieOrTVShow(page: Int? = 1, type: APIRequest, genre: Int, completion: @escaping CompletionHandler) {
        
        self.fetchingMore = true
        
        print("Genre: ----", genreInfo)
        
        QueryService.instance.fetchDiscoverSectioByGenres(type: queryType, genre: genre, page: page!) { (sectionData) in
            
            if let sectionData = sectionData {
                
                self.searchData.page = sectionData.page
                self.searchData.total_pages = sectionData.total_pages
                self.searchData.sectionName = sectionData.sectionName
                self.searchData.sectionArray.append(contentsOf: sectionData.getSectionArray())
                
                self.fetchingMore = false
                
                completion(true)
                
                self.collectionView?.reloadData()
                
            } else { completion(false) }
            
            
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.searchOptionViewCell, for: indexPath) as! SearchOptionCollectionViewCell
        
        let searchArray = searchData.sectionArray
        
        cell.searchTVMovie = searchArray[indexPath.row]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == searchData.sectionArray.count - 1 && searchData.page < searchData.total_pages && !fetchingMore {
            
            discoverMoreMovieOrTVShow(page: searchData.page + 1, type: queryType, genre: genreInfo.id) {_ in }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.frame.width / 2) - 30, height: 283.0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selected = searchData.sectionArray[indexPath.row]
        
        self.performSegue(withIdentifier: Segue.fromSearchOptionToDetail, sender: selected)
    }
}
