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
            
            toViewController.sectionData = (sender as? SectionData)
        }
        
        if segue.identifier == Segue.toSearchList {
            
            let toViewController = segue.destination as! SearchListCollectionViewController
            
            toViewController.queryType = .Movie
        }
    }
    
    func loadMovieListData() {
        
        LoadingIndicatorView.show("Loading")
        
        QueryService.intance.fetchAllSection(sectionArray: sectionMovieInfo) {
            (sectionArray) in
            
            if let sectionArray = sectionArray {
                self.sectionMovieArray = sectionArray
                self.tableView.reloadData()
            }
            
            LoadingIndicatorView.hide()
        }
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
        
        
        if let showDetails = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.movieDetailsViewController) as? TVMovieDetailsViewController {
            
            showDetails.modalPresentationStyle = .overFullScreen
            showDetails.modalTransitionStyle = .crossDissolve
            
            showDetails.queryType = .Movie
            showDetails.information = section.sectionArray[indexPath.row]
            
            self.present(showDetails, animated: true, completion: nil)
        }
        
       /* if movie.title == "More" {
            
            // Remove More TVShow row
            section.sectionArray.removeLast()
            
            let data: SectionMovie = SectionMovie(page: section.page, total_results: section.total_results, total_pages: section.total_pages, sectionName: "\(section.sectionName) list", sectionArray: section.sectionArray)
            
            self.performSegue(withIdentifier: Segue.toMovieList, sender: data)
            
        } else { } */
        
    }
}













