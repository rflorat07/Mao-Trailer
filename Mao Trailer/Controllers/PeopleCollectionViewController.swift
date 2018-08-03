//
//  PeopleCollectionViewController.swift
//  Mao Trailer
//
//  Created by Roger Florat on 03/08/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class PeopleCollectionViewController: UICollectionViewController {

    var peopleData: People!
    var fetchingMore: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadPopularData()
    }

    func loadPopularData() {
        
        LoadingIndicatorView.show("Loading")
        
        QueryService.instance.fetchPopularPeople(page: 1) { (popular) in
            
            if let popular = popular {
                self.peopleData = popular
                self.collectionView?.reloadData()
            }
            
            LoadingIndicatorView.hide()
        }
    }
    
    func fetchMorePopularPeople(page: Int) {
        
        self.fetchingMore = true
        
        self.collectionView?.performBatchUpdates({
            
            QueryService.instance.fetchPopularPeople(page: page) { (morePopular) in
                
                self.fetchingMore = false
                
                if let morePopular = morePopular {
                    self.peopleData.page = morePopular.page
                    self.peopleData.results.append(contentsOf: morePopular.results)
                    self.collectionView?.reloadData()
                }
                
            }
            
        }, completion: nil)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segue.fromPeopleToPersonDetails {
            
            let navigationContoller = segue.destination as! UINavigationController
            
            let receiverViewController = navigationContoller.topViewController as! PersonDetailsTableViewController
            
            receiverViewController.personId = sender as? Int
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {

        return peopleData != nil ? 1 : 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return peopleData.results.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.peopleCollectionViewCell, for: indexPath) as! PeopleCollectionViewCell
        
        cell.people = peopleData.results[indexPath.row]
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == peopleData.results.count - 3 && peopleData.page < peopleData.total_pages && !fetchingMore {
            
            self.fetchMorePopularPeople(page: peopleData.page + 1)
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selected = peopleData.results[indexPath.row]
        
        self.performSegue(withIdentifier: Segue.fromPeopleToPersonDetails, sender: selected.id)
    }

}
