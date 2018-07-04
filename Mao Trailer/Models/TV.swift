//
//  TV.swift
//  Mao Trailer
//
//  Created by Roger Florat on 03/07/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import Foundation

struct TVShow: Decodable {
    let id: Int
    let name: String
    let overview: String
    let poster_path: String
    let vote_average: Double
    let first_air_date: String
    let backdrop_path : String
    let original_name : String
    
    
    /* enum CodingKeys: String, CodingKey {
     case title = "name"
     } */
}

struct TVShowList: Decodable {
    let results: [TVShow]
}
