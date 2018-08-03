//
//  PersonDetailsHeaderTableViewCell.swift
//  Mao Trailer
//
//  Created by Roger Florat on 30/07/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class PersonDetailsHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var posterCoverView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var knownForLabel: UILabel!
    @IBOutlet weak var biographyLabel: UILabel!

    let cornerRadius: CGFloat = Constants.cornerRadius
    
    var details: PersonDetails! {
        didSet{
            updateUI()
        }
    }
        
    func updateUI(){

        nameLabel.text = details.name.uppercased()
        biographyLabel.text = details.biography
        knownForLabel.text = details.knownForFilmography()
        categoriesLabel.text = details.known_for_department
        birthdayLabel.text = details.getBirthdayAndPlace()
        
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = Constants.cornerRadius
        posterImageView.downloadedFrom(urlString: details.profile_path!)
        
        posterCoverView.dropShadow(radius: Constants.cornerRadius)
    }
        
    override func prepareForReuse() {
        nameLabel.text = ""
        birthdayLabel.text = ""
        knownForLabel.text = ""
        biographyLabel.text = ""
        categoriesLabel.text = ""
        posterImageView.image = nil
    }
    

}
