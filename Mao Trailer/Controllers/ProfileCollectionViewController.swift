//
//  ProfileCollectionViewController.swift
//  Mao Trailer
//
//  Created by Roger Florat on 27/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class ProfileCollectionViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        
        return ProfileList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        if  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.profileListViewCell, for: indexPath) as? ProfileListCollectionViewCell {
            
            cell.posterImage = ProfileList[indexPath.row].poster_path
            
            return cell
        }
    
        return UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let movieDetail = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.movieDetailViewController) as? MovieDetailViewController {
            
            movieDetail.modalPresentationStyle = .overFullScreen
            movieDetail.modalTransitionStyle = .crossDissolve
            
            movieDetail.movie = ProfileList[indexPath.row]
            
            self.present(movieDetail, animated: true, completion: nil)
        }
        
    }

}
