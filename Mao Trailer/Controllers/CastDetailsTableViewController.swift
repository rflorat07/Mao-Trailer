//
//  CastDetailsTableViewController.swift
//  Mao Trailer
//
//  Created by Roger Florat on 30/07/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class PersonDetailsTableViewController: UITableViewController {
    
    var person: Cast!
    var personDetails = PersonDetails()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadInitialData()
    }
    
    func loadInitialData() {
    
        LoadingIndicatorView.show("Loading")
        
        QueryService.instance.fetchPersonInformation(personId: person.id) { (personInformation) in
            
            if let details = personInformation {
                self.personDetails = details
                
                print(details)
                
                self.tableView.reloadData()
            }
            
            LoadingIndicatorView.hide()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Section 1 - Header Person Details
        // Section 2 - Filmography
        
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return indexPath.section == 0 ? 375 : 275
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.headerPersonDetailsViewCell, for: indexPath) as! HeaderPersonDetailsTableViewCell
            
            cell.details = personDetails
            
            return cell
            
        }
        
       return UITableViewCell()
    }
}
