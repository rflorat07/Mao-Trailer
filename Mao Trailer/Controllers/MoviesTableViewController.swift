//
//  MoviesTableViewController.swift
//  Mao Trailer
//
//  Created by Roger Florat on 19/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class MoviesTableViewController: UITableViewController {
    
    var movieList: [Movie] = [Movie]()
    
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
        
        QueryServiceMovie.intance.getDiscoverMovie(queryString: EndPoint.NowMovies) { (movies)  in
            
            if let movies = movies {
                self.movieList = movies
                self.tableView.reloadData()
            }
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
        
        return section == 0 ? 1 : 2
    }
    
    //Height for each section
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return indexPath.section == 0 ? 180 : 310
    }
    
    //Deque Tableview cell for rows
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.hotViewCell, for: indexPath) as! HotTableViewCell
            
            cell.hotMovies = movieList
            
            cell.didSelectAction = { (movie) in
                
                if movie.title == "More" {
                    let data: SectionMovie = SectionMovie(sectionName: "Hot list", movieArray: self.movieList)
                    
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
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.sectionViewCell, for: indexPath) as! SectionTableViewCell
            
            let section = SectionMoviesList[indexPath.row]
            
            cell.sectionMovies = movieList
            cell.sectionTitleLabel.text = section.sectionName
            
            cell.didSelectAction = { (movie) in
                
                if movie.title == "More" {
                    
                    let data: SectionMovie = SectionMovie(sectionName: "\(section.sectionName) list" , movieArray: self.movieList)
                    
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
    }
}













