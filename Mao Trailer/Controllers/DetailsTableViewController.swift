//
//  DetailsTableViewController.swift
//  Mao Trailer
//
//  Created by Roger Florat on 01/08/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit
import Kingfisher

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
    
    @IBOutlet weak var coverImageViewTop: NSLayoutConstraint!
    @IBOutlet weak var coverImageViewHeight: NSLayoutConstraint!
    
    var details: Details!
    var queryType: MediaType!
    var information: TVMovie!
    
    var originalTop: CGFloat!
    var originalHeight: CGFloat!
    var originalNavBarHeight: CGFloat!
    
    let cornerRadius: CGFloat = Constants.cornerRadius
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initStretchyHeadersVar()
        self.loadInformationData()
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
        
        self.clearDataDetails()
        
        LoadingIndicatorView.show("Loading")
        
        QueryService.instance.fetchPrimaryInformation(id: information.id, type: queryType) { (details) in
            
            if let details = details {
                self.details = details
                self.loadDataDetails()
                self.tableView.reloadData()
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
        
        self.playButton.isHidden = false
        self.startImageView.isHidden = false
        self.footerActionView.isHidden = false
        
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
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            print("Favorite Button Tapped")
        case 2:
            print("Watchlist Button Tapped")
        case 3:
            print("Rate Button Tapped")
        default:
            print("None Button Tapped")
        }
     
        sender.isSelected = !sender.isSelected
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
                self.performSegue(withIdentifier: Segue.fromDetailsToPersonDetails, sender: castSelected.id)
            }
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.detailImagesTableViewCell, for: indexPath) as! DetailImagesTableViewCell
            
            cell.images = details.images.backdrops
            
            cell.didSelectAction = { (indexPath) in
                self.performSegue(withIdentifier: Segue.fromDetailsToImagePreview, sender: indexPath)
            }
            
            return cell
        }
    }
}
