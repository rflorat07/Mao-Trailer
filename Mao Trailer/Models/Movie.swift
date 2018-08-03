//
//  Movie.swift
//  Mao Trailer
//
//  Created by Roger Florat on 21/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import Foundation

struct Movie: Decodable, TVMovie {

    let id: Int
    let title: String
    let overview: String?
    let popularity: Double
    let poster_path: String?
    let vote_count : Double
    let vote_average: Double
    let release_date: String?
    let backdrop_path: String?
    let original_title: String
    
    func getVoteCount() -> String {
        return "(based on \(self.vote_count) ratings)"
    }
    
    func getReleaseDate() -> String {
        return  Date.getFormattedDate(string: self.release_date!)
    }
    
    func getRatingValue() -> String {
        return String(format:"%.1f", self.vote_average)
    }
}


