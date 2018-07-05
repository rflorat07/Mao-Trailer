//
//  Movie.swift
//  Mao Trailer
//
//  Created by Roger Florat on 21/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import Foundation


protocol TVFilm {
    
    var id: Int { get }
    var title: String { get }
    var overview: String { get }
    var poster_path: String { get }
    var vote_average: Double { get }
    var release_date: String { get }
    var backdrop_path : String { get }
    var original_title : String { get }
}


struct Movie: Decodable, TVFilm {
    
    let id: Int
    let title: String
    let overview: String
    let poster_path: String
    let vote_average: Double
    let release_date: String
    let backdrop_path : String
    let original_title : String
}

struct MovieList: Decodable {
    let results: [Movie]
}

struct SectionMovie {
    var sectionName: String
    var movieArray: [TVFilm]
}



