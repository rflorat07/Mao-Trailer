//
//  Section.swift
//  Mao Trailer
//
//  Created by Roger Florat on 06/07/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import Foundation

// MARK: - Section

protocol Section  {
    var page: Int { get }
    var total_pages: Int { get }
    var sectionName: String { get }
    var sectionArray: [TVMovie] { get set}
}

struct SectionData: Section {
    var page: Int
    var total_pages: Int
    var sectionName: String
    var sectionArray: [TVMovie]
}

struct SectionInfo {
    var page: Int
    var type: QueryType
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

// MARK: - TV Movie Info

protocol TVMovie {
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


