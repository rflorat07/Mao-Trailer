//
//  PersonDetailsTableViewController.swift
//  Mao Trailer
//
//  Created by Roger Florat on 30/07/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class PersonDetailsTableViewController: UITableViewController {
    
    var personId: Int!
    var mediaType: APIRequest!
    var personDetails: PersonDetails!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.changeStatusBarStyle(statusBarStyle: .default)
        
        self.loadInitialData()
    }
    
    func loadInitialData() {
    
        LoadingIndicatorView.show("Loading")
        
        QueryService.instance.fetchPersonInformation(personId: personId) { (personInformation) in
            
            if let details = personInformation {
                self.personDetails = details
                self.tableView.reloadData()
            }
            
            LoadingIndicatorView.hide()
        }

    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segue.fromPersonDetailsToDetails {
            
            let navigationContoller = segue.destination as! UINavigationController
            
            let receiverViewController = navigationContoller.topViewController as! DetailsTableViewController
            
            receiverViewController.queryType = mediaType
            
            switch mediaType.rawValue {
            case "movie":
                receiverViewController.information = sender as? Movie
            default:
                receiverViewController.information = sender as? TVShow
            }
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
       // dismiss(animated: true, completion: nil)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Section 1 - Header Person Details
        // Section 2 - Filmography
        // Section 3 - TVShows
        
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  personDetails != nil ? 1 : 0
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return indexPath.section == 0 ? 375 : 295
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.headerPersonDetailsViewCell, for: indexPath) as! PersonDetailsHeaderTableViewCell
            
            cell.details = personDetails
            
            return cell
            
        } else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.filmographyTableViewCell, for: indexPath) as! PersonDetailsInfoTableViewCell
            
            cell.filmography = personDetails.getFilmography()
            
            cell.didSelectAction = { (movieSelected) in
                
                self.mediaType = .Movie
                
                self.performSegue(withIdentifier: Segue.fromPersonDetailsToDetails, sender: movieSelected)
            }
            
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.tvShowsTableViewCell, for: indexPath) as! PersonDetailsInfoTableViewCell
            
            cell.filmography = personDetails.getTVShows()
            
            cell.didSelectAction = { (tvShowSelected) in
                
                self.mediaType = .TV
                
                self.performSegue(withIdentifier: Segue.fromPersonDetailsToDetails, sender: tvShowSelected)
            }
            
            return cell
        }
        
    }
}
