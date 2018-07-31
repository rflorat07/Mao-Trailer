//
//  ListCollectionViewController.swift
//  Mao Trailer
//
//  Created by Roger Florat on 21/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class ListCollectionViewController: UICollectionViewController {
    
    var queryType: MediaType!
    var fetchingMore: Bool = false
    var sectionData: SectionData = SectionData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 
        if segue.identifier == Segue.toListDetail {
        
            let navigationContoller = segue.destination as! UINavigationController
            
            let receiverViewController = navigationContoller.topViewController as! DetailsViewController
            
            receiverViewController.queryType = queryType
            
            switch queryType.rawValue {
            case "movie":
                receiverViewController.information = sender as? Movie
            default:
                receiverViewController.information = sender as? TVShow
            }
        }
    }
    
    
    func fetchMoreMovies(page: Int) {
    
        self.fetchingMore = true
        
        self.collectionView?.performBatchUpdates({
            
            QueryService.instance.fetchSection(sectionName: sectionData.sectionName, type: queryType, endPoint: .Popular, page: page, { (sectionData) in
                
                self.fetchingMore = false
                
                if let sectionData = sectionData {
        
                    self.sectionData.page = sectionData.page
                    self.sectionData.sectionArray.append(contentsOf: sectionData.getSectionArray())
                    
                    self.collectionView?.reloadData()
                }
            })
        
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
        
        if indexPath.row == sectionData.sectionArray.count - 1 && sectionData.page < sectionData.total_pages && !fetchingMore {
         
            self.fetchMoreMovies(page: sectionData.page + 1)
        }
    }
    

    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selected = sectionData.sectionArray[indexPath.row]
        
        self.performSegue(withIdentifier: Segue.toListDetail, sender: selected)
    }
}
