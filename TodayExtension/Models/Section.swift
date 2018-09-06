//
//  File.swift
//  TodayExtension
//
//  Created by Roger Florat on 03/09/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import Foundation


struct SectionData: Decodable {
    
    var page: Int
    var total_pages: Int
    var sectionName: String?
    var results: [Movie]
    
    func getDiscoverMovieArray() -> [Movie] {
       return self.results.filter{ $0.poster_path != nil || $0.backdrop_path != nil }
    }
    
    init() {
        page = 0
        total_pages = 0
        sectionName = ""
        results = [Movie]()
    }
}

struct SectionError: Decodable {
    var status_code: Int?
    var status_message: String?
}
