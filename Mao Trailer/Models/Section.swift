//
//  Section.swift
//  Mao Trailer
//
//  Created by Roger Florat on 06/07/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import Foundation

// MARK: - Section

struct SectionData: Section {
    
    var page: Int
    var total_pages: Int
    var sectionName: String
    var sectionArray: [TVMovie] {
        didSet {
            sectionArray = self.sectionArray.filter{ $0.poster_path != nil && $0.backdrop_path != nil }
        }
    }
    
    init() {
        page = 0
        total_pages = 0
        sectionName = ""
        sectionArray = [TVMovie]()
    }
    
    init(page: Int, total_pages: Int, sectionName: String, sectionArray: [TVMovie]) {
        self.page   = page
        self.total_pages = total_pages
        self.sectionName  = sectionName
        self.sectionArray = sectionArray
    }

    func getSectionArray() -> [TVMovie] {
        return sectionArray.filter{ $0.poster_path != nil && $0.backdrop_path != nil }
    }
}

struct SectionInfo {
    var page: Int
    var type: MediaType
    var sectionName: String
    var endPoint: EndPointType
}

struct SectionMovieArray: Decodable {
    var page: Int
    var total_pages: Int
    var results: [Movie]
}

struct SectionTVArray: Decodable {
    var page: Int
    var total_pages: Int
    var results: [TVShow]
}


struct SectionError: Decodable {
    var status_code: Int?
    var status_message: String?
}

// MARK: - Protocol

protocol Section  {
    var page: Int { get }
    var total_pages: Int { get }
    var sectionName: String { get }
    var sectionArray: [TVMovie] { get set}
    
    func getSectionArray() -> [TVMovie]
}

protocol TVMovie {
    var id: Int { get }
    var title: String { get }
    var overview: String { get }
    var popularity: Double { get }
    var poster_path: String? { get set}
    var vote_count : Double { get }
    var vote_average: Double { get }
    var release_date: String { get }
    var backdrop_path : String? { get set}
    var original_title : String { get }
    
}


