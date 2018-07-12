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
    let overview: String
    let popularity: Double
    var poster_path: String?
    let vote_average: Double
    let release_date: String
    var backdrop_path: String?
    let original_title: String
}


