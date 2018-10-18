//
//  TVTableViewController.swift
//  Mao Trailer
//
//  Created by Roger Florat on 21/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class TVTableViewController: UITableViewController {
    
    let sectionTVInfo = [
        SectionInfo(page: 1, type: .TV, sectionName: "Today", endPoint: .TodayTV),
        SectionInfo(page: 1, type: .TV, sectionName: "Currently Airing", endPoint: .OnTheAirTV)
    ]
    
    let network = NetworkManager.sharedInstance
    
    var endpointRequest: EndpointRequest!
    var sectionTVShowArray: [SectionData] = [SectionData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if NetworkManager.isConnected() {
            self.loadTVShowListData()
        }
        
        network.reachability.whenReachable = { _ in
            if NetworkManager.isConnected() {
                self.loadTVShowListData()
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segue.fromTVToList {
            
            let toViewController = segue.destination as! ListCollectionViewController
            
            toViewController.queryType = .TV
            toViewController.sectionData = sender as! SectionData
            toViewController.endpointRequest = self.endpointRequest
        }
        
        if segue.identifier == Segue.fromTVToSearchList {
            
            let toViewController = segue.destination as! SearchListCollectionViewController
            
            toViewController.queryType = .TV
            toViewController.searchData = SectionData()
        }
        
        if segue.identifier == Segue.fromTVToDetail {
            
            let navigationContoller = segue.destination as! UINavigationController
            
            let receiverViewController = navigationContoller.topViewController as! DetailsTableViewController
            
            receiverViewController.queryType = .TV
            receiverViewController.information = sender as? TVShow
        }
    }
    
    func loadTVShowListData() {
        
        LoadingIndicatorView.show("Loading")
        
        QueryService.instance.fetchAllSection(sectionArray: sectionTVInfo) { (sectionArray) in
            
            if let sectionArray = sectionArray {
                self.sectionTVShowArray = sectionArray
                self.appendMoreTVShowItem()
                self.tableView.reloadData()
            }
            
            LoadingIndicatorView.hide()
        }
    }
    
    func appendMoreTVShowItem() {
        
        self.sectionTVShowArray = self.sectionTVShowArray.map({ (sectionData)  in
            
            var section = sectionData
            
            if section.sectionArray.count > 10 {
                section.sectionArray.append(MoreTVShow)
            }
            return section
        })
    }

    
    @IBAction func searchButtonTapped(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: Segue.fromTVToSearchList, sender: nil)
    }
}

extension TVTableViewController {
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        // Section 1 - Now [TVShow]
        // Section 2 - SectionLabel
        // Section 3 - Popular [TVShow]
        
        return sectionTVShowArray.count > 0 ? 3 : 0
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Section 0 - Now [TVShow]
        // Section 1 - SectionLabel
        // Section 2 - Popular [TVShow]
        
        return section != 2 ? 1 : sectionTVShowArray[1].sectionArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 260
        } else if indexPath.section == 1 {
            return 61
        } else {
            return 213
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.tvNowViewCell, for: indexPath) as? TVNowTableViewCell {
                
                var section = sectionTVShowArray[indexPath.section]
                let endPoint = sectionTVInfo[indexPath.section].endPoint
                
                cell.selectionStyle = .none
                
                cell.nowTVShows = section.sectionArray
                
                cell.didSelectAction = { (indexPath) in
                    
                    if NetworkManager.isConnected() {
                        self.showTVShowDetails(indexPath: indexPath, section: section, endPoint: endPoint)
                    } else {
                        Helpers.alertNoInternetConnection()
                    }
                    
                }
                
                return cell
            }
            
            
        } else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.tvSectionLabelViewCell, for: indexPath)
            
            cell.selectionStyle = .none
            
            return cell
            
            
        } else if indexPath.section == 2 {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.tvPopularViewCell, for: indexPath) as? TVPopularTableViewCell {
                
                var section = sectionTVShowArray[indexPath.section - 1]
 
                cell.selectionStyle = .none
                
                cell.tvShow = (section.sectionArray[indexPath.row] as! TVShow)
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 2 {
            
            let section = sectionTVShowArray[indexPath.section - 1]
            let endPoint = sectionTVInfo[indexPath.section - 1].endPoint
            
            if NetworkManager.isConnected() {
                self.showTVShowDetails(indexPath: indexPath, section: section, endPoint: endPoint)
            } else {
                Helpers.alertNoInternetConnection()
            }
        }
    }
    
    // MARK: - Helper methods
    
    fileprivate func showTVShowDetails(indexPath: IndexPath, section: SectionData, endPoint: EndpointRequest) {
        
        self.endpointRequest = endPoint
        let tvShowSelected = section.sectionArray[indexPath.row]
        
         if tvShowSelected.title == "More" {
            
            // Remove more item
            var sectionArray = section.sectionArray
            
            sectionArray.removeLast()
            
         let data: SectionData = SectionData(page: section.page, total_pages: section.total_pages, sectionName: "\(section.sectionName) list", sectionArray: sectionArray)
        
         self.performSegue(withIdentifier: Segue.fromTVToList, sender: data)
         
         } else {
            
           self.performSegue(withIdentifier: Segue.fromTVToDetail, sender: tvShowSelected)
        }
    }
}

