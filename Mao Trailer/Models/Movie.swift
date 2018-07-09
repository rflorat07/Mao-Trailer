//
//  Movie.swift
//  Mao Trailer
//
//  Created by Roger Florat on 21/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import Foundation

struct MovieList: Decodable {
    let results: [Movie]
}

struct Movie: Decodable, TVFilm {

    let id: Int
    let title: String
    let overview: String
    let popularity: Double
    let poster_path: String
    let vote_average: Double
    let release_date: String
    let backdrop_path: String
    let original_title: String
}

struct SectionMovie: SectionTVMovie {
    var sectionName: String
    var sectionArray: [TVFilm]
}

let MoreMovie: Movie = Movie(id: 0, title: "More", overview: "More", popularity: 0.0, poster_path: "land-more", vote_average: 0.0, release_date: "0000-00-00",backdrop_path : "land-more", original_title: "More")


