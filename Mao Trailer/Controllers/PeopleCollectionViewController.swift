//
//  PeopleCollectionViewController.swift
//  Mao Trailer
//
//  Created by Roger Florat on 03/08/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class PeopleCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var searchButtonItem: UIBarButtonItem!
    
    var peopleData: People!
    var peopleDataTemp: People!
    var searchText: String = ""
    var fetchingMore: Bool = false
    var searchButtonToShow: UIBarButtonItem!
    
    let searchBar = UISearchBar()
    let network = NetworkManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchButtonToShow = self.searchButtonItem
        
        if NetworkManager.isConnected() {
            self.loadPopularData()
        }
        
        network.reachability.whenReachable = { _ in
            if NetworkManager.isConnected() {
                self.loadPopularData()
            }
        }
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
                
                DispatchQueue.main.async {
                    self.fetchingMore = false
                    
                    if let morePopular = morePopular {
                        self.peopleData.page = morePopular.page
                        self.peopleData.results.append(contentsOf: morePopular.results)
                        self.collectionView?.reloadData()
                    }
                }
            }
        }, completion: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segue.fromPeopleToPersonDetails {
            
            let toViewController = segue.destination as! PersonDetailsTableViewController
            
            toViewController.personId = sender as? Int
        }
    }
    
    @IBAction func searchButtonTapped(_ sender: UIBarButtonItem) {
        self.createSearchBar()
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return peopleData != nil ? 1 : 0
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return peopleData.getPopularArray().count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.peopleCollectionViewCell, for: indexPath) as! PeopleCollectionViewCell
    
        cell.people = peopleData.getPopularArray()[indexPath.row]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == peopleData.getPopularArray().count - 3 && peopleData.page < peopleData.total_pages && !fetchingMore {
            
            self.fetchMorePopularPeople(page: peopleData.page + 1)
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selected = peopleData.getPopularArray()[indexPath.row]
        
        if NetworkManager.isConnected() {
            self.performSegue(withIdentifier: Segue.fromPeopleToPersonDetails, sender: selected.id)
        } else {
            Helpers.alertNoInternetConnection()
        }

    }
    
}


extension PeopleCollectionViewController: UISearchBarDelegate {
    
    func createSearchBar() {
        
        searchBar.delegate = self
        
        searchBar.sizeToFit()
        searchBar.becomeFirstResponder()
        searchBar.showsCancelButton = true
        searchBar.placeholder = "Enter you search here!"
        searchBar.tintColor = Colors.headerColor
        
        if let searchTextField = searchBar.value(forKey: "_searchField") as? UITextField {
            searchTextField.backgroundColor = Colors.backgroundColor
        }
        
        self.navigationItem.titleView = searchBar
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = nil
        
        self.peopleDataTemp = peopleData
        self.peopleData = nil
        self.collectionView?.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        
        QueryService.instance.searchForPeople(searchText: searchBar.text!, type: .Person) { (searchData) in
            
            if let searchData = searchData {
                
                self.peopleData = searchData
                self.collectionView?.reloadData()
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            self.peopleData = nil
            self.collectionView?.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.peopleData = self.peopleDataTemp
        self.collectionView?.reloadData()
        
        self.navigationItem.titleView = nil
        self.navigationItem.setRightBarButton(self.searchButtonToShow, animated: true)
    }
    
}
