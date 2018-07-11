//
//  TVTableViewController.swift
//  Mao Trailer
//
//  Created by Roger Florat on 21/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class TVTableViewController: UITableViewController {
    
    var sectionTVShowArray: [SectionTVShow] = [SectionTVShow]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTVShowListData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segue.toMovieList {
            
            let toViewController = segue.destination as! TVMovieListCollectionViewController
            
            toViewController.sectionData = sender as! SectionTVShow
            
        } 
    }
    
    func loadTVShowListData() {
        
        LoadingIndicatorView.show("Loading")
        
        QueryServiceTVShow.intance.fetchAllTVShowsLists { (sectionArray) in
            
            if let sectionArray = sectionArray {
                
                self.sectionTVShowArray = sectionArray
                self.sectionTVShowArray[1].sectionArray.append(MoreTVShow)
                
                self.tableView.reloadData()
                
                LoadingIndicatorView.hide()
                
            }
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
                                
                var section = sectionTVShowArray[indexPath.section]
                
                // Add More TVShow row
                if section.sectionArray.count > 10 {
                    section.sectionArray.append(MoreTVShow)
                }
                
                cell.selectionStyle = .none
                
                cell.nowTVShows = section.sectionArray as! [TVShow]
                
                cell.didSelectAction = { (tvShow) in
                    
                    // Remove More TVShow row
                    section.sectionArray.removeLast()
                    
                    self.showTVShowListOrTVShowDetail(tvShow: tvShow, indexPath: indexPath, section: section)
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
            
            var section = sectionTVShowArray[indexPath.section - 1]
            let tvShow  = section.sectionArray[indexPath.row] as! TVShow
            
            // Remove More TVShow row
            section.sectionArray.removeLast()
            
            showTVShowListOrTVShowDetail(tvShow: tvShow, indexPath: indexPath, section: section)
            
        }
    }
    
    // MARK: - Helper methods
    fileprivate func showTVShowListOrTVShowDetail(tvShow: TVShow, indexPath: IndexPath, section: SectionTVShow) {
        
        if tvShow.title == "More" {
            
            let data: SectionTVShow = SectionTVShow(sectionName: "\(section.sectionName) list", sectionArray: section.sectionArray)
            
            self.performSegue(withIdentifier: Segue.toMovieList, sender: data)
            
        } else {
            
            if let tvShowDetail = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.movieDetailViewController) as? TVMovieDetailViewController {
                
                tvShowDetail.modalPresentationStyle = .overFullScreen
                tvShowDetail.modalTransitionStyle = .crossDissolve
                
                tvShowDetail.detail = tvShow
                
                self.present(tvShowDetail, animated: true, completion: nil)
            }
        }
    }
    
}
