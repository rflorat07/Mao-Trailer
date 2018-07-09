//
//  MovieDetailViewController.swift
//  Mao Trailer
//
//  Created by Roger Florat on 27/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class TVMovieDetailViewController: UIViewController {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var ratingValueLabel: UILabel!
    @IBOutlet weak var posterCoverView: UIView!
    @IBOutlet weak var genreLabel: UILabel!
    
    let cornerRadius: CGFloat = Constants.cornerRadius
    
    var detail: TVFilm!
    var cast: [Cast] = [Cast]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // StatusBar Style
        UIApplication.shared.statusBarStyle = .lightContent
        
        updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // StatusBar Style
        UIApplication.shared.statusBarStyle = .default
    }
    
    func updateUI() {
        
        descriptionLabel.text = detail.overview
        titleLabel.text = detail.title.uppercased()
        
        coverImageView.downloadedFrom(urlString: detail.backdrop_path)
        
        ratingValueLabel.text = String(format:"%.1f", detail.vote_average)
        
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = cornerRadius
        posterImageView.downloadedFrom(urlString: detail.poster_path)
        
        posterCoverView.dropShadow(radius: cornerRadius)
        
        LoadingIndicatorView.show("Loading")
        
        QueryServiceMovie.intance.fetchMovieInformation(movieID: detail.id) { (detail) in
            
            if let detail = detail {
                
                self.cast = detail.credits.cast
                self.genreLabel.text = detail.getGenre()
                
                self.collectionView.reloadData()
                
                LoadingIndicatorView.hide()
            }
        }
    }
    
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension TVMovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.fullCastCollectionViewCell, for: indexPath) as? MovieDetailFullCastCollectionViewCell {
            
            cell.cast = cast[indexPath.row]
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
}







