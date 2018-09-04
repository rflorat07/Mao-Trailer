//
//  Movie.swift
//  TodayExtension
//
//  Created by Roger Florat on 03/09/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

struct Movie: Decodable {
    let id: Int
    let title: String
    let poster_path: String?
    let backdrop_path: String?
}
