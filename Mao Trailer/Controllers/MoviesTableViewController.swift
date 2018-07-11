//
//  MoviesTableViewController.swift
//  Mao Trailer
//
//  Created by Roger Florat on 19/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class MoviesTableViewController: UITableViewController {
    
    var sectionMovieArray: [SectionMovie] = [SectionMovie]()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // StatusBar Style
        UIApplication.shared.statusBarStyle = .default
        
        // Load Movies Data
        loadMovieListData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segue.toMovieList {
            
            let toViewController = segue.destination as! TVMovieListCollectionViewController
            
            toViewController.sectionData = sender as! SectionMovie
        }
    }
    
    func loadMovieListData() {
        
         LoadingIndicatorView.show("Loading")
        
        QueryServiceMovie.intance.fetchAllMoviesLists { (sectionArray) in
            
            if let sectionArray = sectionArray {
                
                self.sectionMovieArray = sectionArray
                self.tableView.reloadData()
                
                 LoadingIndicatorView.hide()
                
            }
        }
        
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
            
            var section = sectionMovieArray[indexPath.section]
            
            // Add More Movie row
            if section.sectionArray.count > 10 {
                section.sectionArray.append(MoreMovie)
            }
            
            cell.hotMovies = section.sectionArray as! [Movie]
            
            cell.didSelectAction = { (movie) in
                
                self.showMovieListOrMovieDetail(movie: movie, indexPath: indexPath, section: section)
            }
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.sectionViewCell, for: indexPath) as! SectionTableViewCell
            
            var section = sectionMovieArray[indexPath.section]
            
            // Add More Movie row
            if section.sectionArray.count > 10 {
                section.sectionArray.append(MoreMovie)
            }
            
            cell.sectionTitleLabel.text = section.sectionName
            cell.sectionMovies = section.sectionArray as! [Movie]
            
            cell.didSelectAction = { (movie) in
                
                self.showMovieListOrMovieDetail(movie: movie, indexPath: indexPath, section: section)
            }
            
            return cell
        }
    }
    
    // MARK: - Helper methods
    fileprivate func showMovieListOrMovieDetail(movie: Movie, indexPath: IndexPath, section: SectionMovie) {
        
        if movie.title == "More" {
            
            let data: SectionMovie = SectionMovie(sectionName: "\(section.sectionName) list", sectionArray: section.sectionArray)
            
            self.performSegue(withIdentifier: Segue.toMovieList, sender: data)
            
        } else {
            
            if let movieDetail = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.movieDetailViewController) as? TVMovieDetailViewController {
                
                movieDetail.modalPresentationStyle = .overFullScreen
                movieDetail.modalTransitionStyle = .crossDissolve
                
                movieDetail.detail = movie
                
                self.present(movieDetail, animated: true, completion: nil)
            }
        }
        
    }
}













