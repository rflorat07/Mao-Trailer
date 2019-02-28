//
//  DetailsTableViewController.swift
//  Mao Trailer
//
//  Created by Roger Florat on 01/08/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit
import AVKit
import Kingfisher
import XCDYouTubeKit

class DetailsTableViewController: UITableViewController {
    
    @IBOutlet weak var startImageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
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
    @IBOutlet weak var footerActionView: UIView!
    
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var favotiteButton: UIButton!
    @IBOutlet weak var watchlistButton: UIButton!
    
    @IBOutlet weak var coverImageViewTop: NSLayoutConstraint!
    @IBOutlet weak var coverImageViewHeight: NSLayoutConstraint!
    
    var details: Details!
    var information: TVMovie!
    var states: AccountStates!
    var queryType: APIRequest!
    
    
    var originalTop: CGFloat!
    var originalHeight: CGFloat!
    var originalNavBarHeight: CGFloat!
    
    let network = NetworkManager.sharedInstance
    let cornerRadius: CGFloat = Constants.cornerRadius
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearDataDetails()
        self.initStretchyHeadersVar()
        
        
        if NetworkManager.isConnected() {
            self.loadInformationData()
        }
        
        network.reachability.whenReachable = { _ in
            if NetworkManager.isConnected() {
                self.loadInformationData()
            }
        }
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
    
    
    func loadInformationData() {
        
        LoadingIndicatorView.show("Loading")
        
        QueryService.instance.fetchPrimaryInformation(id: information.id, type: queryType) { (details) in
            
            if let details = details {
                self.details = details
                self.loadDataDetails()
                self.tableView.reloadData()
                
            }
            
            if AuthenticationService.instanceAuth.isLoggedIn {
                
                AccountService.instanceAccount.fetchAccountStates(id: self.information.id, type: self.queryType, endPoint: EndpointRequest.AccountStates) { (states) in
                    
                    if let states = states {
                        
                        self.states = states
                        
                        self.favotiteButton.isSelected = states.favorite!
                        self.watchlistButton.isSelected = states.watchlist!
                        self.rateButton.isSelected = (states.rated?.value)!
                    }
                }
            }
            
            LoadingIndicatorView.hide()
        }
        
    }
    
    func initStretchyHeadersVar() {
        
        originalTop = coverImageViewTop.constant
        originalHeight = coverImageViewHeight.constant
        originalNavBarHeight = self.navigationController?.navigationBar.frame.height
    }
    
    func clearDataDetails() {
        
        self.titleLabel.text = ""
        self.genreLabel.text = ""
        self.runtimeLabel.text = ""
        self.voteCountLabel.text = ""
        self.releaseDateLabel.text = ""
        self.descriptionLabel.text = ""
        self.ratingValueLabel.text = ""
        
        self.coverImageView.image = nil
        self.posterImageView.image = nil
        
        self.playButton.isHidden = true
        self.startImageView.isHidden = true
        self.footerActionView.isHidden = true
    }
    
    func loadDataDetails() {
        
        self.startImageView.isHidden = false
        self.footerActionView.isHidden = false
        self.playButton.isHidden = self.details.getVideoKey() != "none" ? false : true
        
        self.genreLabel.text = details.getGenre()
        self.descriptionLabel.text = information.overview
        self.runtimeLabel.text = details.getRuntime()
        self.voteCountLabel.text = information.getVoteCount()
        self.titleLabel.text = information.title.uppercased()
        self.releaseDateLabel.text = information.getReleaseDate()
        self.ratingValueLabel.text = information.getRatingValue()
        
        self.posterImageView.clipsToBounds = true
        self.posterImageView.layer.cornerRadius = self.cornerRadius
        self.posterCoverView.dropShadow(radius: self.cornerRadius)
        
        let imagePosterPath = Helpers.downloadedFrom(urlString: self.information.poster_path ?? self.information.backdrop_path!)
        
        self.posterImageView.kf.setImage(with: URL(string: imagePosterPath), placeholder: Constants.placeholderImage)
        
        let imageCoverPath = Helpers.downloadedFrom(urlString: self.information.backdrop_path ?? self.information.poster_path!, size: ImageSize.large)
        
        self.coverImageView.kf.setImage(with: URL(string: imageCoverPath), placeholder: Constants.placeholderImage)
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segue.fromDetailsToPersonDetails {
            
            
            let navigationContoller = segue.destination as! PersonDetailsTableViewController
            
            navigationContoller.modalTransitionStyle = .crossDissolve
            navigationContoller.modalPresentationStyle = .overFullScreen
            
            navigationContoller.personId = sender as? Int
        }
        
        if segue.identifier == Segue.fromDetailsToImagePreview {
            
            let toViewController = segue.destination as! ImagePreviewViewController
            
            toViewController.indexPath = sender as! IndexPath
            toViewController.imgArray = details.images.backdrops!
        }
        
        if segue.identifier == Segue.fromDetailsToRating {
            
            let toViewController = segue.destination as! RatingViewController
            
            let imagePosterPath = Helpers.downloadedFrom(urlString: self.information.poster_path ?? self.information.backdrop_path!)
            
            toViewController.id = information.id
            toViewController.queryType = queryType
            toViewController.imagePath = imagePosterPath
            toViewController.ratedValue = states.rated?.ratedValue
            
            toViewController.callBack = { (hasChanged, value) in
                if hasChanged {
                    self.rateButton.isSelected = true
                    self.states.rated?.ratedValue = value
                    NotificationCenter.default.post(name: .didUserChangedStatus , object: nil)
                }
            }
            
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
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
    
    // MARK: - Action Button
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareTapped(_ sender: UIBarButtonItem) {
        
        guard let posterImage = UIImageJPEGRepresentation(posterImageView.image!, 0.75) else { return }
        
        let items: [Any] = [information.title,posterImage]
        let vc = UIActivityViewController(activityItems: items, applicationActivities: [])
        
        present(vc, animated: true)
    
    }
    
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        
        if AuthenticationService.instanceAuth.isLoggedIn {
            switch sender.tag {
            case 1:
                self.markAsFavoriteOrAddToWatchlist(sender, endPoint: .Favorite)
            case 2:
                self.markAsFavoriteOrAddToWatchlist(sender, endPoint: .Watchlist)
            default:
                self.performSegue(withIdentifier: Segue.fromDetailsToRating, sender: nil)
            }
        }
    }
    
    @IBAction func playVideoTapped(_ sender: UIButton) {
        
        self.playYouTubeVideo(videoIdentifier: self.details.getVideoKey())
    }
    
    struct YouTubeVideoQuality {
        static let hd720 = NSNumber(value: XCDYouTubeVideoQuality.HD720.rawValue)
        static let medium360 = NSNumber(value: XCDYouTubeVideoQuality.medium360.rawValue)
        static let small240 = NSNumber(value: XCDYouTubeVideoQuality.small240.rawValue)
    }
    
    func playYouTubeVideo(videoIdentifier: String?) {
        
        let playerViewController = AVPlayerViewController()
        
        self.present(playerViewController, animated: true)
        
        //Get streamURL
        XCDYouTubeClient.default().getVideoWithIdentifier(videoIdentifier) { [weak playerViewController] (video: XCDYouTubeVideo?, error: Error?) in
            if let streamURLs = video?.streamURLs, let streamURL = (streamURLs[XCDYouTubeVideoQualityHTTPLiveStreaming] ?? streamURLs[YouTubeVideoQuality.hd720] ?? streamURLs[YouTubeVideoQuality.medium360] ?? streamURLs[YouTubeVideoQuality.small240]) {
                playerViewController?.player = AVPlayer(url: streamURL)
                playerViewController?.player?.play()
                
            } else {
                self.dismiss(animated: true)
            }
        }
    }
    
    func markAsFavoriteOrAddToWatchlist(_ sender: UIButton, endPoint: EndpointRequest) {
        
        if AuthenticationService.instanceAuth.isLoggedIn {
            
            LoadingIndicatorView.show("Loading")
            
            AccountService.instanceAccount.markAsFavorite(id: self.information.id, type: self.queryType, endPoint: endPoint, mark: !sender.isSelected) { (response) in
                
                if let response = response {
                    
                    if response.status_code == 1 {
                        
                        sender.isSelected = true
                        
                    } else if response.status_code == 13 {
                        sender.isSelected = false
                    }
                }
                
                NotificationCenter.default.post(name: .didUserChangedStatus , object: nil)
                
                LoadingIndicatorView.hide()
            }
        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        // Section 1 - Cast
        // Section 2 - Images
        
        return details != nil ? 2 : 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return indexPath.section == 0 ? 228 : 195
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.detailCastTableViewCell, for: indexPath) as! DetailCastTableViewCell
            
            cell.cast = details.getCast()
            
            cell.didSelectAction = { (castSelected) in
                
                if NetworkManager.isConnected() {
                    self.performSegue(withIdentifier: Segue.fromDetailsToPersonDetails, sender: castSelected.id)
                } else {
                    Helpers.alertNoInternetConnection()
                }
            }
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.detailImagesTableViewCell, for: indexPath) as! DetailImagesTableViewCell
            
            cell.images = details.images.backdrops
            
            cell.didSelectAction = { (indexPath) in
                
                if NetworkManager.isConnected() {
                    self.performSegue(withIdentifier: Segue.fromDetailsToImagePreview, sender: indexPath)
                } else {
                    Helpers.alertNoInternetConnection()
                }
                
            }
            
            return cell
        }
    }
}
