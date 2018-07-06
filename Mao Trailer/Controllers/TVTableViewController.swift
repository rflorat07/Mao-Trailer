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
            
            let toViewController = segue.destination as! MovieListCollectionViewController
            
            toViewController.movieList = sender as! SectionMovie
            
        } 
    }
    
    func loadTVShowListData() {
        
        LoadingIndicatorView.show("Loading")
        
        QueryServiceTVShow.intance.fetchAllTVShowsLists { (sectionArray) in
            
            if let sectionArray = sectionArray {
                
                self.sectionTVShowArray = sectionArray
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
        
        return section != 2 ? 1 : sectionTVShowArray[1].tvShowsArray.count
        
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
                if section.tvShowsArray.count > 10 {
                    section.tvShowsArray.append(TVShowMore)
                }
                
                cell.selectionStyle = .none
                
                cell.nowTVShows = section.tvShowsArray as! [TVShow]
                
                cell.didSelectAction = { (tvShow) in
                    
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
                
                // Add More TVShow row
                if section.tvShowsArray.count > 10 {
                    section.tvShowsArray.append(TVShowMore)
                }
                
                cell.selectionStyle = .none
                
                cell.tvShows = section.tvShowsArray[indexPath.row] as! TVShow
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 2 {
            
            let section = sectionTVShowArray[indexPath.section - 1]
            let tvShow  = section.tvShowsArray[indexPath.row] as! TVShow
            
            showTVShowListOrTVShowDetail(tvShow: tvShow, indexPath: indexPath, section: section)
            
        }
    }
    
    // MARK: - Helper methods
    fileprivate func showTVShowListOrTVShowDetail(tvShow: TVShow, indexPath: IndexPath, section: SectionTVShow) {
        
        if tvShow.title == "More" {
            
            let data: SectionTVShow = SectionTVShow(sectionName: "\(section.sectionName) list", tvShowsArray: section.tvShowsArray)
            
            self.performSegue(withIdentifier: Segue.toMovieList, sender: data)
            
        } else {
            
            if let movieDetail = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.movieDetailViewController) as? MovieDetailViewController {
                
                movieDetail.modalPresentationStyle = .overFullScreen
                movieDetail.modalTransitionStyle = .crossDissolve
                
                movieDetail.movie = tvShow
                
                self.present(movieDetail, animated: true, completion: nil)
            }
        }
    }
    
}
