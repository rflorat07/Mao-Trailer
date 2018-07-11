//
//  TV.swift
//  Mao Trailer
//
//  Created by Roger Florat on 03/07/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import Foundation

struct TVShow: Decodable, TVFilm {
    
    var id: Int
    var title: String
    var overview: String
    var popularity: Double
    var poster_path: String? 
    var vote_average: Double
    var release_date: String
    var backdrop_path : String?
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


