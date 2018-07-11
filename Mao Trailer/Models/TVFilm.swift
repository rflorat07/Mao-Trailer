//
//  TVFilm.swift
//  Mao Trailer
//
//  Created by Roger Florat on 06/07/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import Foundation

protocol TVFilm {
    var id: Int { get }
    var title: String { get }
    var overview: String { get }
    var popularity: Double { get }
    var poster_path: String? { get }
    var vote_average: Double { get }
    var release_date: String { get }
    var backdrop_path : String? { get }
    var original_title : String { get }
}


protocol SectionTVMovie {
    var sectionName: String { get }
    var sectionArray: [TVFilm] { get }
}


