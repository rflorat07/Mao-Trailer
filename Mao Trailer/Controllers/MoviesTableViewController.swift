//
//  MoviesTableViewController.swift
//  Mao Trailer
//
//  Created by Roger Florat on 19/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class MoviesTableViewController: UITableViewController {
    
    let dataMovies = DataMovies()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segue.toMovieList {
            
            let toViewController = segue.destination as! MovieListCollectionViewController
            
            toViewController.movieList = sender as! Section
            
        } else if  segue.identifier == Segue.toMovieDetail {
            
            let toViewController = segue.destination as! MovieDetailTableViewController
            
            toViewController.movie = sender as! Movie
            
        }
    }
}

extension MoviesTableViewController {
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // 0 - Hot [Movie]
        // 1 - Popular [Section]
        
        return 2
    }
    
    //Number of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Section 0 - Hot [Movie]
        // Section 1 - Section [Section]
        
        return section == 0 ? 1 : self.dataMovies.sectionMovies.count
    }
    
    //Height for each section
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return indexPath.section == 0 ? 180 : 310
    }
    
    //Deque Tableview cell for rows
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.hotViewCell, for: indexPath) as! HotTableViewCell
            
            cell.hotMovies = dataMovies.hotMovies
            
            cell.didSelectAction = { (movie) in
                
                if movie.title == "More" {
                    let data: Section = Section(sectionName: "Hot list", movieArray: self.dataMovies.hotMovies)
                    
                    self.performSegue(withIdentifier: Segue.toMovieList, sender: data)
                    
                } else {
                    
                    self.performSegue(withIdentifier: Segue.toMovieDetail, sender: movie)
                }
                
            }
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.sectionViewCell, for: indexPath) as! SectionTableViewCell
            
            let section = dataMovies.sectionMovies[indexPath.row]
            
            cell.sectionMovies = section.movieArray
            cell.sectionTitleLabel.text = section.sectionName
            
            cell.didSelectAction = { (movie) in
                
                if movie.title == "More" {
                    
                    let data: Section = Section(sectionName: "\(section.sectionName) list" , movieArray: section.movieArray)
                    
                    self.performSegue(withIdentifier: Segue.toMovieList, sender: data)
                    
                } else {
                    
                    self.performSegue(withIdentifier: Segue.toMovieDetail, sender: movie)
                }
                
            }
            
            return cell
        }
    }
}













