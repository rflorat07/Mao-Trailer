//
//  Constants.swift
//  TodayExtension
//
//  Created by Roger Florat on 03/09/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import Foundation

enum APIRequest: String {
    case TV = "tv"
    case Movie = "movie"
    case Discover = "discover"
}

enum EndpointRequest: String {
    case Discover = "discover"
    case Popular  = "popular"
    case Upcoming = "upcoming"
    case TopRated = "top_rated"
}

struct QueryString {
    static let page = "1"
    static let region = "IT"
    static let language = "en-US"
    static let sort_by = "release_date.asc"
    static let api_key = "3b122cc1b16808da5a679c3c1c11cd07"
    static let baseUrl = "https://api.themoviedb.org"
}

struct ImageSize {
    static let large = "/w500"
    static let medium = "/w400"
    static let thumbnails = "/w200"
    static let original = "original"
    static let placeholderImage = "placeholder"
    static let baseUrl = "https://image.tmdb.org/t/p"
}
