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
            
            let toViewController = segue.destination as! MovieListCollectionViewController
            
            toViewController.movieList = sender as! SectionMovie
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
            if section.movieArray.count > 10 {
                section.movieArray.append(MoreMovie)
            }
            
            cell.hotMovies = section.movieArray as! [Movie]
            
            cell.didSelectAction = { (movie) in
                
                self.showMovieListOrMovieDetail(movie: movie, indexPath: indexPath, sectionName: section.sectionName)
            }
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.sectionViewCell, for: indexPath) as! SectionTableViewCell
            
            var section = sectionMovieArray[indexPath.section]
            
            // Add More Movie row
            if section.movieArray.count > 10 {
                section.movieArray.append(MoreMovie)
            }
            
            cell.sectionTitleLabel.text = section.sectionName
            cell.sectionMovies = section.movieArray as! [Movie]
            
            cell.didSelectAction = { (movie) in
                
                self.showMovieListOrMovieDetail(movie: movie, indexPath: indexPath, sectionName: section.sectionName)
            }
            
            return cell
        }
    }
    
    // MARK: - Helper methods
    fileprivate func showMovieListOrMovieDetail(movie: Movie, indexPath: IndexPath, sectionName: String) {
        
        if movie.title == "More" {
            
            let section = self.sectionMovieArray[indexPath.section]
            
            let data: SectionMovie = SectionMovie(sectionName: "\(sectionName) list" , movieArray: section.movieArray)
            
            self.performSegue(withIdentifier: Segue.toMovieList, sender: data)
            
        } else {
            
            if let movieDetail = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.movieDetailViewController) as? MovieDetailViewController {
                
                movieDetail.modalPresentationStyle = .overFullScreen
                movieDetail.modalTransitionStyle = .crossDissolve
                
                movieDetail.movie = movie
                
                self.present(movieDetail, animated: true, completion: nil)
            }
        }
        
    }
}













