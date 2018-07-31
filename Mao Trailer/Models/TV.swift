//
//  TV.swift
//  Mao Trailer
//
//  Created by Roger Florat on 03/07/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import Foundation

struct TVShow: Decodable, TVMovie {
 
    let id: Int
    let title: String
    let overview: String
    let popularity: Double
    var poster_path: String?
    let vote_count : Double
    let vote_average: Double
    let release_date: String?
    var backdrop_path : String?
    let original_title : String
    
     enum CodingKeys: String, CodingKey {
        case id
        case title = "name"
        case overview
        case popularity
        case poster_path
        case vote_count
        case vote_average
        case release_date = "first_air_date"
        case backdrop_path
        case original_title = "original_name"
    }
}


