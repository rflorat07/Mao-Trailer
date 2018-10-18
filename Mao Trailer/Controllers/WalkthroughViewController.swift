//
//  WalkthroughViewController.swift
//  Mao Trailer
//
//  Created by Roger Florat on 29/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class WalkthroughViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInsetAdjustmentBehavior = .never
        
        configurePageControl()
    }
    
    func configurePageControl() {
        
        self.pageControl.currentPage = 0
        self.pageControl.isEnabled = false
        self.pageControl.numberOfPages = WalkthroughList.count
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
    @objc func goToMovieTab() {
        
        UserDefaults.standard.set(true, forKey: UserInfo.walkthrough)
        AppDelegate.shared.switchToMainTabBarController()

    }
    
    @objc func scrollToNextCell(){
        
        //get cell size
        let cellSize = view.frame.size
        
        //get current content Offset of the Collection view
        let contentOffset = collectionView.contentOffset
        
        if collectionView.contentSize.width <= contentOffset.x + cellSize.width
        {
            let r = CGRect(x: 0, y: contentOffset.y, width: cellSize.width, height: cellSize.height)
            collectionView.scrollRectToVisible(r, animated: true)
            
            pageControl.currentPage = 0
            
            
        } else {
            let r = CGRect(x: contentOffset.x + cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height)
            collectionView.scrollRectToVisible(r, animated: true);
            
            pageControl.currentPage = Int(round((contentOffset.x + cellSize.width) / cellSize.width))
        }
        
    }
    
}

extension WalkthroughViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return WalkthroughList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.walkthroughViewCell, for: indexPath) as? WalkthroughCollectionViewCell {
            
            cell.getStaredButtonView.isHidden = true
            
            cell.walkthroughData = WalkthroughList[indexPath.row]
            
            if indexPath.row == WalkthroughList.count - 1 {
                cell.nextButtonView.isHidden = true
                cell.getStaredButtonView.isHidden = false
            }
            
            cell.nextButton.addTarget(self, action: #selector(WalkthroughViewController.scrollToNextCell), for: .touchUpInside)
            
            
            cell.getStaredButton.addTarget(self, action: #selector(WalkthroughViewController.goToMovieTab), for: .touchUpInside)
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    
    
    
}
