//
//  ProfileCollectionViewController.swift
//  Mao Trailer
//
//  Created by Roger Florat on 27/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class ProfileCollectionViewController: UICollectionViewController {
    
    var sectionArray: SectionData!
    var accountDetails: AccountDetails!
    var ratedSectionArray: SectionData!
    var favoriteSectionArray: SectionData!
    var watchlistSectionArray: SectionData!
    
    let sectionProfileInfo = [
        SectionInfo(page: 1, type: .Account, sectionName: "Favorite", endPoint: .FavoriteMovies),
        SectionInfo(page: 1, type: .Account, sectionName: "Watchlist", endPoint: .WatchlistMovies),
        SectionInfo(page: 1, type: .Account, sectionName: "Ratings", endPoint: .RatedMovies)]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AuthenticationService.instanceAuth.isLoggedIn {
            self.loadProfileData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !AuthenticationService.instanceAuth.isLoggedIn {
            self.performSegue(withIdentifier: Segue.fromProfileLoginToProfile, sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segue.fromProfileLoginToProfile {
            
            let toViewController = segue.destination as? LoginViewController
            
            toViewController?.callback = { (response) in
                if response {
                    self.loadProfileData()
                }
            }
        }
        
        if segue.identifier == Segue.fromProfileToDetail {
            
            let navigationContoller = segue.destination as! UINavigationController
            
            let receiverViewController = navigationContoller.topViewController as! DetailsTableViewController
            
            receiverViewController.queryType = .Movie
            receiverViewController.information = sender as? Movie
        }
        
        if segue.identifier == Segue.fromProfileToProfileSetting {
            
            let toViewController = segue.destination as? ProfileSettingViewController
            
            toViewController?.callback = { (response) in
                self.accountDetails = nil
                self.sectionArray = nil
                self.collectionView?.reloadData()
            }
        }
    }
    
    
    func loadProfileData() {
        
        LoadingIndicatorView.show("Loading")
        
        QueryService.instance.fetchAllSection(sectionArray: sectionProfileInfo) { (sectionArray) in
            
            if let sectionArray = sectionArray {
                
                self.sectionArray = sectionArray[0]
                self.favoriteSectionArray = sectionArray[0]
                self.watchlistSectionArray = sectionArray[1]
                self.ratedSectionArray = sectionArray[2]
                
                self.collectionView?.reloadData()
            }
            
            LoadingIndicatorView.hide()
        }
        
        
        AccountService.instanceAccount.fetchAccountDetails { (details) in
            if let details = details {
                self.accountDetails = details
                self.collectionView?.reloadData()
            }
        }
    }
    
    
    @IBAction func settingButton(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: Segue.fromProfileToProfileSetting, sender: self)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Storyboard.profileHeaderReusableView, for: indexPath) as? ProfileHeaderCollectionReusableView {
            
            if let accountDetails = accountDetails {
                sectionHeader.profile = accountDetails
                sectionHeader.favoritesLabel.text = String(favoriteSectionArray.sectionArray.count)
                sectionHeader.watchingLabel.text = String(watchlistSectionArray.sectionArray.count)
                sectionHeader.ratingsLabel.text = String(ratedSectionArray.sectionArray.count)
            }
            
            sectionHeader.didSelectAction = { (selected) in
                
                switch selected {
                case "Favorites":
                    
                    self.sectionArray = self.favoriteSectionArray
                    self.collectionView?.reloadData()
                    
                case "Watching":
                    
                    self.sectionArray = self.watchlistSectionArray
                    self.collectionView?.reloadData()
                    
                default:
                    self.sectionArray = self.ratedSectionArray
                    self.collectionView?.reloadData()
                }
            }
            
            return sectionHeader
        }
        
        return UICollectionReusableView()
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return sectionArray != nil ? 1 : 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return sectionArray.sectionArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.profileListViewCell, for: indexPath) as? ProfileListCollectionViewCell {
            
            let section = sectionArray.sectionArray
            
            cell.posterImage = section[indexPath.row].poster_path
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selected = sectionArray.sectionArray[indexPath.row]
        
        self.performSegue(withIdentifier: Segue.fromProfileToDetail, sender: selected)
        
    }
}


