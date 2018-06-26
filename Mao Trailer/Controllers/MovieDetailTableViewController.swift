//
//  MovieDetailTableViewController.swift
//  Mao Trailer
//
//  Created by Roger Florat on 25/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class MovieDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var ratingValueLabel: UILabel!
    
    
    var movie: Movie!
    var dataCast = DataMovies()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        changeNavigationBar(true)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeNavigationBar(false)
    }
    
    func updateUI() {
        
        titleLabel.text = movie.title?.uppercased()
        titleLabel.sizeToFit()
        
        ratingValueLabel.text = String(format:"%.1f", movie.rate!)
        
        coverImageView.clipsToBounds = true
        coverImageView.image = UIImage(named: movie.imgUrl)
        
        posterImageView.clipsToBounds = true
        posterImageView.image = UIImage(named: movie.imgUrl)
        posterImageView.layer.cornerRadius = Constants.cornerRadius
    }
    
    func changeNavigationBar(_ change: Bool) {
        
        if change {
            
            // NavigationBar Style
            
            self.navigationController!.navigationBar.isTranslucent = true
            self.navigationController!.navigationBar.shadowImage = UIImage()
            self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
            
            // StatusBar Style
            UIApplication.shared.statusBarStyle = .lightContent
            
        } else {
            
            // NavigationBar Style
            self.navigationController!.navigationBar.isTranslucent = false
            self.navigationController!.navigationBar.shadowImage = UIImage()
            self.navigationController!.navigationBar.setBackgroundImage(nil, for: .default)
            
            // StatusBar Style
            UIApplication.shared.statusBarStyle = .default
        }
    }
}


extension MovieDetailTableViewController {
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        // 1 - Description
        // 2 - Full Cast & Crew
        
        return 2
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {

            if let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.movieDetailDescriptionViewCell, for: indexPath) as? MovieDetailDescriptionTableViewCell {
                
                cell.descriptionLabel.text = movie.description
            }
        } else if indexPath.row == 1 {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.movieDetailFullCastViewCell, for: indexPath) as? MovieDetailFullCastTableViewCell {
                
                cell.fullCastCollectionView.delegate = self
                cell.fullCastCollectionView.dataSource = self
                cell.fullCastCollectionView.reloadData()
                
                cell.sectionLabel.text = "Full Cast & Crew"
                
            }
            
        }
    
        return UITableViewCell()
     }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return indexPath.row == 0 ? 140 : 270
    }
}


extension MovieDetailTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataCast.fullCast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.fullCastCollectionViewCell, for: indexPath) as? MovieDetailFullCastCollectionViewCell {
            
            cell.cast = dataCast.fullCast[indexPath.row]
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    
    
}

