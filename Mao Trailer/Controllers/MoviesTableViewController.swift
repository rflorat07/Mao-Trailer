//
//  MoviesTableViewController.swift
//  Mao Trailer
//
//  Created by Roger Florat on 19/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class MoviesTableViewController: UITableViewController {
    
    let sections = ["Now", "Popular"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    struct Storyboard {
        static let hotTableViewCell = "HotTableViewCell"
        static let hotCollectionViewCell = "HotCollectionViewCell"
        static let sectionTableViewCell = "SectionTableViewCell"
        static let sectionCollectionViewCell = "SectionCollectionViewCell"
    }
    
}

extension MoviesTableViewController {
    
    // MARK: - Table view data source
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // 0 - Hot Section
        // 1 - Popular Section
        
        return 2
    }
    
    //Number of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Section 0 - Hot Section
        // Section 1 - [Now, Popular]
        
        return section == 0 ? 1 : self.sections.count
    }
    
    //Height for each section
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 200 : 309
    }
    
    //Deque Tableview cell for rows
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.hotTableViewCell, for: indexPath) as! HotTableViewCell
            
            cell.selectionStyle = .none
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.sectionTableViewCell, for: indexPath) as! SectionTableViewCell
            
            cell.selectionStyle = .none
            cell.sectionTitleLabel.text = self.sections[indexPath.row]
            
            return cell
        }
    }
}













