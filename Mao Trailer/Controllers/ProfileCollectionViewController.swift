//
//  ProfileCollectionViewController.swift
//  Mao Trailer
//
//  Created by Roger Florat on 27/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class ProfileCollectionViewController: UICollectionViewController {
    
    let sectionProfileInfo = [SectionInfo(page: 1, type: .TV, sectionName: "Popular", endPoint: .Popular)]
    
    var sectionProfileArray: SectionData = SectionData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadProfileData()
    }

    func loadProfileData() {
        
        LoadingIndicatorView.show("Loading")
        
        QueryService.instance.fetchAllSection(sectionArray: sectionProfileInfo) { (sectionArray) in
            
            if let sectionArray = sectionArray {
                self.sectionProfileArray = sectionArray[0]
                self.collectionView?.reloadData()
            }
            
            LoadingIndicatorView.hide()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segue.toProfileDetail {
            
            let navigationContoller = segue.destination as! UINavigationController
            
            let receiverViewController = navigationContoller.topViewController as! DetailsViewController
            
            receiverViewController.queryType = .TV
            receiverViewController.information = sender as? TVShow
        }
    }
    

    @IBAction func settingButton(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: Segue.toProfileSetting, sender: nil)
    }
        
   
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Storyboard.profileHeaderReusableView, for: indexPath) as? ProfileHeaderCollectionReusableView {
            
            sectionHeader.avatarImage = "avatar"
            
            return sectionHeader
        }
        
        return UICollectionReusableView()
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return sectionProfileArray.sectionArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        if  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.profileListViewCell, for: indexPath) as? ProfileListCollectionViewCell {
            
            let section = sectionProfileArray.sectionArray
            
            cell.posterImage = section[indexPath.row].poster_path
            
            return cell
        }
    
        return UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selected = sectionProfileArray.sectionArray[indexPath.row]
        
        self.performSegue(withIdentifier: Segue.toProfileDetail, sender: selected)
        
    }

}

