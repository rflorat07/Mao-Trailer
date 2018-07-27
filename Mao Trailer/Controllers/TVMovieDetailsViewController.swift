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
    
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
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
    
    var originalTop: CGFloat!
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
        
        // Init Stretchy Headers var
        originalTop = coverImageViewTop.constant
        originalHeight = coverImageViewHeight.constant
        originalNavBarHeight = self.navigationController?.navigationBar.frame.height
        
        self.loadViewData()
        self.fetchPrimaryInformation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Change navigationBar
        self.navigationController?.changeNavigationBarToTransparent()
        self.navigationController?.changeStatusBarStyle(statusBarStyle: .lightContent)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Reset navigationBar
        self.navigationController?.initNavigationBar()
        self.navigationController?.changeStatusBarStyle(statusBarStyle: .default)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segue.toImagePreview {
            
            let toViewController = segue.destination as! ImagePreviewViewController
            
            toViewController.imgArray = images
            toViewController.indexPath = sender as! IndexPath
            
        }
    }
    
    func loadViewData() {
        
        self.descriptionLabel.text = self.information.overview
        self.titleLabel.text = self.information.title.uppercased()
        self.voteCountLabel.text = "(based on \(self.information.vote_count) ratings)"
        self.ratingValueLabel.text = String(format:"%.1f", self.information.vote_average)
        self.releaseDateLabel.text = Date.getFormattedDate(string: self.information.release_date)
        
        self.posterImageView.clipsToBounds = true
        self.posterImageView.layer.cornerRadius = self.cornerRadius
        self.posterImageView.downloadedFrom(urlString: self.information.poster_path ?? self.information.backdrop_path!)
        
        self.posterCoverView.dropShadow(radius: self.cornerRadius)
        
        self.coverImageView.downloadedFrom(urlString: self.information.backdrop_path ?? self.information.poster_path!)
    }
    
    func fetchPrimaryInformation() {
        
        QueryService.instance.fetchPrimaryInformation(id: information.id, type: queryType) { (details) in
            
            if let details = details {
                
                self.cast = details.getCast()
                self.videoKey = "xoGgcdpIQ3I"
                self.genreLabel.text = details.getGenre()
                self.runtimeLabel.text = Date.getFormattedTime(minute: details.runtime ?? 0.0)
                
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
    
    func UpdateCoverImageConstant(scrollView: UIScrollView) {
        
        let imageTop = -originalTop
        let offset = scrollView.contentOffset.y
        
        if offset < imageTop {
            coverImageViewTop.constant = offset
            coverImageViewHeight.constant = originalHeight + abs(imageTop - offset)
        } else {
            coverImageViewTop.constant = imageTop
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
                
                self.navigationController?.updateNavigationBarAppearance(tintColor: tintColor, backgroundColor: backgroundColor)
                self.navigationController?.changeStatusBarStyle(statusBarStyle: .default)
                
            })
        }
        else
        {
            UIView.animate(withDuration: 0.2, animations: {
                
                let tintColor = UIColor.white
                let backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: offset)
                
                self.navigationController?.updateNavigationBarAppearance(tintColor: tintColor, backgroundColor: backgroundColor)
                self.navigationController?.changeStatusBarStyle(statusBarStyle: .lightContent)
            })
        }
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
