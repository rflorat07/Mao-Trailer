//
//  TV.swift
//  Mao Trailer
//
//  Created by Roger Florat on 03/07/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import Foundation

struct TVShow: Decodable, TVFilm {
    
    let id: Int
    let title: String
    let overview: String
    let popularity: Double
    let poster_path: String
    let vote_average: Double
    let release_date: String
    let backdrop_path : String
    let original_title : String
    
     enum CodingKeys: String, CodingKey {
        case id
        case title = "name"
        case overview
        case popularity
        case poster_path
        case vote_average
        case release_date = "first_air_date"
        case backdrop_path
        case original_title = "original_name"
    }
}

struct TVShowList: Decodable {
    let results: [TVShow]
}

struct SectionTVShow: SectionTVMovie {
    var sectionName: String
    var sectionArray: [TVFilm]
}

let MoreTVShow: TVShow = TVShow(id: 0, title: "More", overview: "More",popularity: 0.0, poster_path: "land-more", vote_average: 0.0, release_date: "0000-00-00",backdrop_path : "land-more", original_title: "More")


