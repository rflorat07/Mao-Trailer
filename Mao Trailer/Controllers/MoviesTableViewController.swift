//
//  MoviesTableViewController.swift
//  Mao Trailer
//
//  Created by Roger Florat on 19/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class MoviesTableViewController: UITableViewController {
    
    let sectionMovieInfo = [
        SectionInfo(page: 1, type: .Discover, sectionName: "Discover", endPoint: .DiscoverMovie),
        SectionInfo(page: 1, type: .Movie, sectionName: "Now", endPoint: .NowMovie),
        SectionInfo(page: 1, type: .Movie, sectionName: "Popular", endPoint: .Popular),
        SectionInfo(page: 1, type: .Movie, sectionName: "Top Rated", endPoint: .TopRated),
        ]
    
    let network = NetworkManager.sharedInstance
    
    var endpointRequest: EndpointRequest!
    var sectionMovieArray: [SectionData]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if NetworkManager.isConnected() {
            self.loadMovieListData()
        }
        
        network.reachability.whenReachable = { _ in
            if NetworkManager.isConnected() {
                self.loadMovieListData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        self.navigationController?.changeStatusBarStyle(statusBarStyle: .default)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segue.fromMovieToList {
            
            let toViewController = segue.destination as! ListCollectionViewController
            
            toViewController.sectionData = sender as! SectionData
            toViewController.endpointRequest = self.endpointRequest
            toViewController.queryType = self.endpointRequest.rawValue != "movie" ? .Movie : .Discover
        }
        
        if segue.identifier == Segue.fromMovieToSearchList {
            
            let toViewController = segue.destination as! SearchListCollectionViewController
            
            toViewController.queryType = .Movie
            toViewController.searchData = SectionData()
        }
        
        if segue.identifier == Segue.fromMovieToDetail {
            
            let navigationContoller = segue.destination as! UINavigationController
            
            let receiverViewController = navigationContoller.topViewController as! DetailsTableViewController

            receiverViewController.queryType = .Movie
            receiverViewController.information = sender as? Movie
        }
    }
    
    func loadMovieListData() {
        
        LoadingIndicatorView.show("Loading")
        
        QueryService.instance.fetchAllSection(sectionArray: sectionMovieInfo) {
            (sectionArray) in
            
            if let sectionArray = sectionArray {
                self.appendMoreMovieItem(sectionArray)
                self.checkIfTodayExtensionHasValue()
                self.tableView.reloadData()
            }
            
            LoadingIndicatorView.hide()
        }
    }
    
    func appendMoreMovieItem(_ sectionArray: [SectionData]) {
        
        self.sectionMovieArray = sectionArray.map({ ( section:  SectionData ) in
            
            var _section = section
            
            if _section.sectionArray.count > 10 {
                _section.sectionArray.append(MoreMovie)
            }
            
            return _section
        })
    }
    
    func checkIfTodayExtensionHasValue() {
        
        if let value = QueryService.instance.todayExtension, let sectionArray = sectionMovieArray  {
            
            let index = Int(value)!
            let section = sectionArray[0] // Section Discover
            let movieSelected = section.sectionArray[index]
            
            QueryService.instance.todayExtension = nil
    
            self.performSegue(withIdentifier: Segue.fromMovieToDetail, sender: movieSelected)
        }
    }
    
    
    @IBAction func searchButtonTapped(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: Segue.fromMovieToSearchList, sender: nil)
    }
    
}

extension MoviesTableViewController {
    
    // MARK: - Table view data source
    
    //Number of section
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        // Section 1 - Discover  [Section]
        // Section 2 - Now       [Section]
        // Section 3 - Popular   [Section]
        // Section 4 - Top Rated [Section]
        
        return sectionMovieArray != nil ? sectionMovieArray.count : 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Section 1 - Discover  [Section]
        // Section 2 - Now       [Section]
        // Section 3 - Popular   [Section]
        // Section 4 - Top Rated [Section]
        
        return 1
    }
    
    //Height for each section
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return indexPath.section == 0 ? 190 : 310
    }
    
    //Deque Tableview cell for rows
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.hotViewCell, for: indexPath) as! HotTableViewCell
            
            var section = sectionMovieArray[indexPath.section]
            let endPoint = self.sectionMovieInfo[indexPath.section].endPoint
            
            cell.hotMovies = section.sectionArray
            
            cell.didSelectAction = { (indexPath) in
                
                if NetworkManager.isConnected() {
                    self.showMovieDetails(indexPath: indexPath, section: &section, endPoint: endPoint)
                } else {
                    Helpers.alertNoInternetConnection()
                }
                
            }
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.sectionViewCell, for: indexPath) as! SectionTableViewCell
            
            var section = sectionMovieArray[indexPath.section]
            let endPoint = self.sectionMovieInfo[indexPath.section].endPoint
        
            cell.sectionMovies = section
            
            cell.didSelectAction = { (indexPath) in
                
                if NetworkManager.isConnected() {
                    self.showMovieDetails(indexPath: indexPath, section: &section, endPoint: endPoint)
                } else {
                    Helpers.alertNoInternetConnection()
                }
            }
            
            return cell
        }
    }
    
    // MARK: - Helper methods
    
    fileprivate func showMovieDetails(indexPath: IndexPath, section: inout SectionData, endPoint: EndpointRequest) {
        
        self.endpointRequest = endPoint
        let movieSelected = section.sectionArray[indexPath.row]
        
        if movieSelected.title == "More" {
            
            // Remove more item
           var sectionArray =  section.sectionArray
            
            sectionArray.removeLast()
        
            let data: SectionData = SectionData(page: section.page, total_pages: section.total_pages, sectionName: "\(section.sectionName) list", sectionArray: sectionArray)
            
            self.performSegue(withIdentifier: Segue.fromMovieToList, sender: data)
            
        } else {
            
            self.performSegue(withIdentifier: Segue.fromMovieToDetail, sender: movieSelected)
        }
    }
}













