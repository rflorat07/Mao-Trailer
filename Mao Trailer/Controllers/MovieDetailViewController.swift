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
        
        descriptionLabel.text = movie.overview
        titleLabel.text = movie.title.uppercased()
        
        self.loadImage(withPath: movie)
        
        ratingValueLabel.text = String(format:"%.1f", movie.vote_average)
        
        
        posterImageView.clipsToBounds = true
        posterImageView.image = UIImage(named: movie.poster_path)
        posterImageView.layer.cornerRadius = cornerRadius
        
        posterCoverView.dropShadow(radius: cornerRadius)
    }
    
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func loadImage(withPath: Movie) {
        
        var downloadImage = UIImage()
        
        //Download Image
        let imageString = "https://image.tmdb.org/t/p/w500\(withPath.backdrop_path)"
        guard let imageUrl = URL(string: imageString) else { return }
        let imageProcessor = QueryService()
        imageProcessor.downloadImage(withPath: imageUrl) { (data, response, error) in
            
            DispatchQueue.main.async {
                guard let imageData = data else { return }
                downloadImage = UIImage(data: imageData)!
                self.coverImageView.image = downloadImage
            }
        }
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







