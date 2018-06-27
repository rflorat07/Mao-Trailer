//
//  TVTableViewController.swift
//  Mao Trailer
//
//  Created by Roger Florat on 21/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class TVTableViewController: UITableViewController {

    let dataMovies = DataMovies()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segue.toMovieList {
            
            let toViewController = segue.destination as! MovieListCollectionViewController
            
            toViewController.movieList = sender as! Section
            
        } 
    }
}

extension TVTableViewController {
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {

        // 0 - Now [Movie]
        // 1 - Section Label
        // 2 - Popular [Section]
        
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        // 0 - Now [Movie]
        // 1 - SectionLabel
        // 2 - Popular [Section]
        
        return section < 2 ? 1 : dataMovies.tvMovies.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 260
        } else if indexPath.section == 1 {
            return 61
        } else if indexPath.section == 2 {
            return 213
        }
        
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if indexPath.section == 0 {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.tvNowViewCell, for: indexPath) as? TVNowTableViewCell {
                
                cell.selectionStyle = .none
                cell.nowMovies = dataMovies.nowMovies
                
                cell.didSelectAction = { (movie) in
                    
                    if movie.title == "More" {
                        
                        let data: Section = Section(sectionName: "Now list", movieArray: self.dataMovies.nowMovies)
                        
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
                
                return cell
            }
            
        
        } else if indexPath.section == 1 {
            
             let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.tvSectionLabelViewCell, for: indexPath)
                
                cell.selectionStyle = .none
                return cell
    

        } else if indexPath.section == 2 {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.tvPopularViewCell, for: indexPath) as? TVPopularTableViewCell {
                
                cell.tvShows = dataMovies.tvMovies[indexPath.row]
                
                cell.selectionStyle = .none
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 2 {
            
             let movie: Movie = dataMovies.tvMovies[indexPath.row]
            
            if movie.title == "More" {
                
                let data: Section = Section(sectionName: "Popular list", movieArray: self.dataMovies.tvMovies)
                
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
    
}
