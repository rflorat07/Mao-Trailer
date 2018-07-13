//
//  TVMovieDetailsViewController.swift
//  Mao Trailer
//
//  Created by Roger Florat on 27/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit
import AVKit

class TVMovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var ratingValueLabel: UILabel!
    @IBOutlet weak var posterCoverView: UIView!
    @IBOutlet weak var genreLabel: UILabel!
    
    let cornerRadius: CGFloat = Constants.cornerRadius
    
    var videoKey: String = ""
    var information: TVMovie!
    var cast: [Cast] = [Cast]()
    var queryType: QueryType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // StatusBar Style
        UIApplication.shared.statusBarStyle = .lightContent
        
        self.updateUI()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // StatusBar Style
        UIApplication.shared.statusBarStyle = .default
    }
    
    func updateUI() {
        
        descriptionLabel.text = information.overview
        titleLabel.text = information.title.uppercased()
        ratingValueLabel.text = String(format:"%.1f", information.vote_average)
        
        self.fetchPrimaryInformation()
        self.setBackdropOrPosterPathImage()
    }
    
    func fetchPrimaryInformation() {
        
        LoadingIndicatorView.show("Loading")
        
        QueryService.intance.fetchPrimaryInformation(id: information.id, type: queryType) { (details) in
            
            if let details = details {
                self.cast = details.getCast()
                self.videoKey = "xoGgcdpIQ3I"
                self.genreLabel.text = details.getGenre()
                
                self.collectionView.reloadData()
            }
            
            LoadingIndicatorView.hide()
        }
    }
    
    func setBackdropOrPosterPathImage() {
        
        if information.backdrop_path == nil && information.poster_path != nil {
            information.backdrop_path = information.poster_path
            
        } else if information.backdrop_path != nil && information.poster_path == nil {
            information.poster_path = information.backdrop_path
            
        } else if information.backdrop_path == nil && information.poster_path == nil {
            information.poster_path = "placeholder"
            information.backdrop_path = "placeholder"
        }
        
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = cornerRadius
        posterImageView.downloadedFrom(urlString: information.poster_path!)
        
        posterCoverView.dropShadow(radius: cornerRadius)
        
        coverImageView.downloadedFrom(urlString: information.backdrop_path!)
        
    }
    
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        
        let urlString = "https://www.youtube.com/watch?v=\(self.videoKey)"
        let url = URL(string: urlString)
        let player = AVPlayer(url: url!)
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
        
        print(urlString)
    }
    
}

extension TVMovieDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
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







