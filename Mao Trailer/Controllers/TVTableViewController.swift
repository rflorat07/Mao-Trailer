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
        SectionInfo(page: 1, type: .TV, sectionName: "Now", endPoint: .NowTV),
        SectionInfo(page: 1, type: .TV, sectionName: "Popular", endPoint: .Popular)
    ]
    
    var sectionTVShowArray: [SectionData] = [SectionData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTVShowListData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segue.toMovieList {
            
            let toViewController = segue.destination as! TVMovieListCollectionViewController
            
            toViewController.sectionData = sender as! SectionData
            
        } 
    }
    
    func loadTVShowListData() {
        
        LoadingIndicatorView.show("Loading")
        
        QueryService.intance.fetchAllSection(sectionArray: sectionTVInfo) { (sectionArray) in
            
            if let sectionArray = sectionArray {
                self.sectionTVShowArray = sectionArray
                self.tableView.reloadData()
            }
            
            LoadingIndicatorView.hide()
        }
    }
}

extension TVTableViewController {
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        // Section 1 - Now [TVShow]
        // Section 2 - SectionLabel
        // Section 3 - Popular [TVShow]
        
        return sectionTVShowArray.count != 0 ? 3 : 0
        
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
                
                let section = sectionTVShowArray[indexPath.section]
                
                cell.selectionStyle = .none
                
                cell.nowTVShows = section.sectionArray
                
                cell.didSelectAction = { (indexPath) in
                    
                    self.showTVShowDetails(indexPath: indexPath, section: section)
                    
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
                
                cell.tvShow = section.sectionArray[indexPath.row] as! TVShow
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 2 {
            
            let section = sectionTVShowArray[indexPath.section - 1]
            
            self.showTVShowDetails(indexPath: indexPath, section: section)
            
        }
    }
    
    // MARK: - Helper methods
    
    fileprivate func showTVShowDetails(indexPath: IndexPath, section: SectionData) {
        
        
        if let showDetails = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.movieDetailsViewController) as? TVMovieDetailsViewController {
            
            showDetails.modalPresentationStyle = .overFullScreen
            showDetails.modalTransitionStyle = .crossDissolve
            
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
