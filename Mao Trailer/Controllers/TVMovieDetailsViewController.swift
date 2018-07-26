//
//  TVMovieDetailsViewController.swift
//  Mao Trailer
//
//  Created by Roger Florat on 27/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit
import AVKit

class TVMovieDetailsViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var posterCoverView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingValueLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var castCollectionView: UICollectionView!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var coverImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var coverImageViewTop: NSLayoutConstraint!

    var originalHeight: CGFloat!
    var originalNavBarHeight: CGFloat!
    
    let cornerRadius: CGFloat = Constants.cornerRadius
    
    var videoKey: String = ""
    var information: TVMovie!
    var queryType: MediaType!
    var cast: [Cast] = [Cast]()
    var images: [Image] = [Image]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        castCollectionView.delegate = self
        castCollectionView.dataSource = self
        
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
                
        self.updateUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.makeNavigationBarTransparent()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.resetNavigationBar()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segue.toImagePreview {
            
            let toViewController = segue.destination as! ImagePreviewViewController
            
            toViewController.imgArray = images
            toViewController.indexPath = sender as! IndexPath
            
        }
    }
    
    func updateUI() {
        
        // Stretchy Headers
        originalHeight = coverImageViewHeight.constant
        originalNavBarHeight = self.navigationController?.navigationBar.frame.height
                
        // Information
        descriptionLabel.text = information.overview
        titleLabel.text = information.title.uppercased()
        ratingValueLabel.text = String(format:"%.1f", information.vote_average)
        
        self.fetchPrimaryInformation()
        self.setBackdropOrPosterPathImage()
    }
    
    
    func UpdateCoverImageConstant(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let originalTop  = -originalNavBarHeight
        
        if offset < originalTop {
            coverImageViewTop.constant = offset
            coverImageViewHeight.constant = originalHeight + abs(originalTop - offset)
        } else {
            coverImageViewTop.constant = originalTop
            coverImageViewHeight.constant = originalHeight
        }
    
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.UpdateCoverImageConstant(scrollView: scrollView)
        
        var offset = scrollView.contentOffset.y / 150
        
        if offset > 0.5
        {
            UIView.animate(withDuration: 0.2, animations: {
                offset = min(1,offset)
                
                let backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: offset)
                let tintColor = UIColor.init(hue: 1, saturation: 0, brightness: 0, alpha: offset)
                
                self.navigationController?.updateNavigationBarAppearance(tintColor: tintColor, backgroundColor: backgroundColor, statusBarStyle: .default)
                
            })
        }
        else
        {
            UIView.animate(withDuration: 0.2, animations: {
                
                let tintColor = UIColor.white
                let backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: offset)
                
                self.navigationController?.updateNavigationBarAppearance(tintColor: tintColor, backgroundColor: backgroundColor, statusBarStyle: .lightContent)
            })
        }
    }
    
    func fetchPrimaryInformation() {
        
        QueryService.instance.fetchPrimaryInformation(id: information.id, type: queryType) { (details) in
            
            if let details = details {
                self.cast = details.getCast()
                self.videoKey = "xoGgcdpIQ3I"
                self.genreLabel.text = details.getGenre()
                
                self.castCollectionView.reloadData()
            }
        }
        
        QueryService.instance.fetchImagesInformation(id: information.id, type: queryType) { (images) in
            if let images = images {
                self.images = images.backdrops!
                self.imagesCollectionView.reloadData()
            }
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
        
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
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
    }
}

extension TVMovieDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.castCollectionView {
            return cast.count
        } else {
            return images.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.castCollectionView {
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.fullCastCollectionViewCell, for: indexPath) as? DetailFullCastCollectionViewCell {
                
                cell.cast = cast[indexPath.row]
                
                return cell
            }
        } else  if collectionView == self.imagesCollectionView {
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.imagesCollectionViewCell, for: indexPath) as? DetailImagesCollectionViewCell {
                
                cell.backdropImage = images[indexPath.row]
                
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.imagesCollectionView {
            performSegue(withIdentifier: Segue.toImagePreview, sender: indexPath)
        }
    }
}
