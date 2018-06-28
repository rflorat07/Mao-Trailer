//
//  MovieDetailViewController.swift
//  Mao Trailer
//
//  Created by Roger Florat on 27/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var ratingValueLabel: UILabel!

    var movie: Movie!
    var dataCast = DataMovies()
    
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
        
        descriptionLabel.text = movie.description
        titleLabel.text = movie.title?.uppercased()
        coverImageView.image = UIImage(named: movie.imgUrl)
        ratingValueLabel.text = String(format:"%.1f", movie.rate!)
        
        posterImageView.clipsToBounds = true
        posterImageView.image = UIImage(named: movie.imgUrl)
        posterImageView.layer.cornerRadius = Constants.cornerRadius
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    

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







