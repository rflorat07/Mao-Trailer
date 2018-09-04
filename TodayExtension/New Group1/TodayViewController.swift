//
//  TodayViewController.swift
//  TodayExtension
//
//  Created by Roger Florat on 03/09/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var seeAllView: UIView!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var sectionData: SectionData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadingLabel.isHidden = true
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
        self.loadInitData()
    }
    
    func loadInitData() {
        
        self.loadingLabel.isHidden = false
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            QueryService.instance.fetchDiscoverMovies(type: .Movie , page: 1) { (sectionData) in
                DispatchQueue.main.async {
                    if let sectionData = sectionData {
                        self.sectionData = sectionData
                        self.collectionView.reloadData()
                    }
                }
                
                self.loadingLabel.isHidden = true
            }
        }
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
       self.loadInitData()
        completionHandler(.newData)
        
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        
        if activeDisplayMode == .compact {
            self.preferredContentSize = maxSize
            self.fadeOut()
        } else if activeDisplayMode == .expanded {
            self.preferredContentSize = CGSize(width: maxSize.width, height: 185)
            self.fadeIn()
        }
    }
    
    
    func fadeIn(){
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
            self.seeAllView.alpha = 1.0
        }, completion: nil)
    }
    
    
    func fadeOut(){
        UIView.animate(withDuration: 0.1, delay: 0.0, options:
            .curveEaseOut, animations: {
            self.seeAllView.alpha = 0.0
        }, completion: nil)
    }
    
    func openMaoTrailerApp() {
        let url = URL(string: "mainAppMaoTrailerUrl://")!
        self.extensionContext?.open(url, completionHandler: { (success) in
            if (!success) {
                print("error: failed to open app from Today Extension")
            }
        })
    }
    
    @IBAction func seeAllButtonTapped(_ sender: UIButton) {
        self.openMaoTrailerApp()
    }
}

extension TodayViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sectionData != nil ? 1 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "todayCollectionCell", for: indexPath) as! TodayCollectionViewCell
        
        let discoveryArray = sectionData.getDiscoverMovieArray()
    
        cell.item = discoveryArray[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.openMaoTrailerApp()
    }
    
}
