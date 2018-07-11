//
//  MovieInfo.swift
//  Mao Trailer
//
//  Created by Roger Florat on 04/07/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import Foundation

struct MovieInfo: Decodable {
    let id: Int
    let imdb_id: String
    let genres: [Genre]
    let videos: VideoList
    let credits: CastList
    
    func getGenre() -> String {
        return self.genres.compactMap { $0.name }.joined(separator: ", ")
    }
    
    func getCast() -> [Cast] {
        
        return self.credits.cast.filter{ $0.profile_path != nil }
    }
}

struct Genre: Decodable {
    let id: Int
    var name: String
}

struct VideoList: Decodable {
    let results: [Video]
}

struct Video: Decodable {
    let id: String
    let key: String
    let name: String
    let site: String
    let size: Int
    let type:String
}

struct CastList: Decodable {
    let cast: [Cast]
    // let crew: [Crew]
}

struct Cast: Decodable {
    let name: String
    let character: String
    let profile_path: String?
}

struct Crew: Decodable {
    let job: String
    let name: String
    let profile_path: String?
}
