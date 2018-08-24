//
//  ImagePreviewCollectionViewController.swift
//  Mao Trailer
//
//  Created by Roger Florat on 17/07/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit


class ImagePreviewViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var imgArray = [Image]()
    var indexPath: IndexPath = IndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.contentInsetAdjustmentBehavior = .never
        
        UIApplication.shared.isStatusBarHidden = true
        UIView.animate(withDuration: 0.5, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        })
        
        self.handleSwipeGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.layoutIfNeeded()
        collectionView.scrollToItem(at: self.indexPath, at: .centeredHorizontally, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.isStatusBarHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        })
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func handleSwipeGesture() {
        
        let slideDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissView(gesture:)))
        slideDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(slideDown)
        
        let slideUp = UISwipeGestureRecognizer(target: self, action: #selector(dismissView(gesture:)))
        slideUp.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(slideUp)
    }
    
    
    @objc func dismissView(gesture: UISwipeGestureRecognizer) {
        
        UIView.animate(withDuration: 0.4) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}

extension ImagePreviewViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.imagePreviewCollectionViewCell, for: indexPath) as! ImagePreviewCollectionViewCell
        
        cell.image = imgArray[indexPath.row]
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
