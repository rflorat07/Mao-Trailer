//
//  ListCollectionViewController.swift
//  Mao Trailer
//
//  Created by Roger Florat on 21/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class ListCollectionViewController: UICollectionViewController {
    
    var queryType: APIRequest!
    var fetchingMore: Bool = false
    var endpointRequest: EndpointRequest!
    var sectionData: SectionData = SectionData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 
        if segue.identifier == Segue.fromListToDetail {
        
            let navigationContoller = segue.destination as! UINavigationController
            
            let receiverViewController = navigationContoller.topViewController as! DetailsTableViewController
            
            receiverViewController.queryType = queryType.rawValue != "discover" ? queryType : .Movie
            
            switch queryType.rawValue {
                case "movie", "discover":
                    receiverViewController.information = sender as? Movie
                default:
                    receiverViewController.information = sender as? TVShow
            }
        }
    }
    
    
    func fetchMoreItems(page: Int) {
    
        self.fetchingMore = true
        
        self.collectionView?.performBatchUpdates({
            
            QueryService.instance.fetchSection(sectionName: sectionData.sectionName, type: queryType, endPoint: endpointRequest, page: page, { (sectionData) in
                
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.movieListViewCell, for: indexPath) as! ListCollectionViewCell
        
        cell.movie = sectionData.sectionArray[indexPath.row]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == sectionData.sectionArray.count - 1 && sectionData.page < sectionData.total_pages && !fetchingMore {
         
            self.fetchMoreItems(page: sectionData.page + 1)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selected = sectionData.sectionArray[indexPath.row]
        
        if NetworkManager.isConnected() {
            self.performSegue(withIdentifier: Segue.fromListToDetail, sender: selected)
        } else {
            Helpers.alertNoInternetConnection()
        }
        
    }
}
