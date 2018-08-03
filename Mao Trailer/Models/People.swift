//
//  People.swift
//  Mao Trailer
//
//  Created by Roger Florat on 03/08/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import Foundation

struct People: Decodable  {
    var page: Int
    let total_pages: Int
    let total_results: Int
    var results: [Popular]

}

struct Popular: Decodable {
    let id: Int
    let name: String
    let popularity: Double
    let profile_path: String?
}
