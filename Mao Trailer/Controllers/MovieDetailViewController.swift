//
//  MovieDetailViewController.swift
//  Mao Trailer
//
//  Created by Roger Florat on 27/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var ratingValueLabel: UILabel!
    @IBOutlet weak var posterCoverView: UIView!
    
    let cornerRadius: CGFloat = Constants.cornerRadius
    
    var movie: TVFilm!
    
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
        
        descriptionLabel.text = movie.overview
        titleLabel.text = movie.title.uppercased()
        
        coverImageView.downloadedFrom(urlString: movie.backdrop_path)
        
        ratingValueLabel.text = String(format:"%.1f", movie.vote_average)
        
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = cornerRadius
        posterImageView.downloadedFrom(urlString: movie.poster_path)
        
        posterCoverView.dropShadow(radius: cornerRadius)
    }
    
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}

extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return FullCastList.count
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.fullCastCollectionViewCell, for: indexPath) as? MovieDetailFullCastCollectionViewCell {
            
            cell.cast = FullCastList[indexPath.row]
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
}







