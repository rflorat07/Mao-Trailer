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
        SectionInfo(page: 1, type: .Movie, sectionName: "Upcoming", endPoint: .Upcoming),
        SectionInfo(page: 1, type: .Movie, sectionName: "Now", endPoint: .NowMovie),
        SectionInfo(page: 1, type: .Movie, sectionName: "Popular", endPoint: .Popular),
        ]
    
    var sectionMovieArray: [SectionData] = [SectionData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // StatusBar Style
        UIApplication.shared.statusBarStyle = .default
        
        loadMovieListData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segue.toMovieList {
            
            let toViewController = segue.destination as! TVMovieListCollectionViewController
            
            toViewController.queryType = .Movie
            toViewController.sectionData = sender as! SectionData
        }
        
        if segue.identifier == Segue.toSearchList {
            
            let toViewController = segue.destination as! SearchListCollectionViewController
            
            toViewController.queryType = .Movie
            toViewController.searchData = SectionData()
        }
    }
    
    func loadMovieListData() {
        
        LoadingIndicatorView.show("Loading")
        
        QueryService.instance.fetchAllSection(sectionArray: sectionMovieInfo) {
            (sectionArray) in
            
            if let sectionArray = sectionArray {
                self.sectionMovieArray = sectionArray
                self.appendMoreMovieItem()
                self.tableView.reloadData()
            }
            
            LoadingIndicatorView.hide()
        }
    }
    
    func appendMoreMovieItem() {
        
        self.sectionMovieArray = self.sectionMovieArray.map({ (section)  in
            
            var _section = section
            
            if _section.sectionArray.count > 10 {
                _section.sectionArray.append(MoreMovie)
            }
            return _section
        })
    }
    
    @IBAction func searchButtonTapped(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: Segue.toSearchList, sender: nil)
    }
    
    
    
}

extension MoviesTableViewController {
    
    // MARK: - Table view data source
    
    //Number of section
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        // Section 1 - Upcoming [Section]
        // Section 2 - Now      [Section]
        // Section 3 - Popular  [Section]
        
        return sectionMovieArray.count
    }
    
    //Number of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Section 1 - Upcoming [Section]
        // Section 2 - Now      [Section]
        // Section 3 - Popular  [Section]
        
        return 1
    }
    
    //Height for each section
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return indexPath.section == 0 ? 180 : 310
    }
    
    //Deque Tableview cell for rows
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.hotViewCell, for: indexPath) as! HotTableViewCell
            
            let section = sectionMovieArray[indexPath.section]
            
            cell.hotMovies = section.sectionArray
            
            cell.didSelectAction = { (indexPath) in
                
              self.showMovieDetails(indexPath: indexPath, section: section)
                
            }
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.sectionViewCell, for: indexPath) as! SectionTableViewCell
            
            let section = sectionMovieArray[indexPath.section]
            
            cell.sectionTitleLabel.text = section.sectionName
            cell.sectionMovies = section.sectionArray
            
            cell.didSelectAction = { (indexPath) in
                
                self.showMovieDetails(indexPath: indexPath, section: section)
            }
            
            return cell
        }
    }
    
    // MARK: - Helper methods
    
    fileprivate func showMovieDetails(indexPath: IndexPath, section: SectionData) {
        
        let movieSelected = section.sectionArray[indexPath.row]
        
        if movieSelected.title == "More" {
            
            var _section = section
            _section.sectionArray.removeLast()
            
            let data: SectionData = SectionData(page: section.page, total_pages: section.total_pages, sectionName: "\(section.sectionName) list", sectionArray: _section.sectionArray)
            
            self.performSegue(withIdentifier: Segue.toMovieList, sender: data)
            
        } else {
            
            if let navigationContoller = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.movieDetailsViewController) as? UINavigationController {
                
                navigationContoller.modalPresentationStyle = .overFullScreen
                navigationContoller.modalTransitionStyle = .crossDissolve
                
                let receiverViewController = navigationContoller.topViewController as! TVMovieDetailsViewController
                
                
                receiverViewController.queryType = .Movie
                receiverViewController.information = movieSelected
                
                self.present(navigationContoller, animated: true, completion: nil)
            }
        }
    }
}













