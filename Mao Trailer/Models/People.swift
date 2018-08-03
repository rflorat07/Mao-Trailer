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
    var total_pages: Int
    var total_results: Int
    var results: [Popular]
    
    func getPopularArray() -> [Popular] {
        return self.results.filter{ $0.profile_path != nil }
    }

}

struct Popular: Decodable {
    let id: Int
    let name: String
    let popularity: Double
    let profile_path: String?
}
