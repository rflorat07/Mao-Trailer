//
//  TVMovieDetails.swift
//  Mao Trailer
//
//  Created by Roger Florat on 04/07/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import Foundation

struct Details: Decodable {
    
    let runtime: Double?
    let episode_run_time: Array<Double>?
    let genres: [Genre]
    let images: ImageArray
    let videos: VideoArray
    let credits: CastArray
    
    func getRuntime() -> String {
        
        if let runtime = self.runtime {
            return Date.getFormattedTime(minute: runtime)
        } else if self.episode_run_time != nil && self.episode_run_time!.count > 0 {
            return Date.getFormattedTime(minute: self.episode_run_time![0])
        }
        
        return "0.0s"
    }
    
    func getGenre() -> String {
        return self.genres.compactMap { $0.name }.joined(separator: ", ")
    }
    
    func getCast() -> [Cast] {
        return self.credits.cast.filter{ $0.profile_path != nil }
    }
    
    func getVideoKey() -> String {
        
        if let firstTrailer = videos.results.first(where: { $0.type == "Trailer" }) {
            return firstTrailer.key
        }
        
        return "none"
    }
}

struct GenreArray: Decodable {
    let genres: [Genre]
}

struct Genre: Decodable {
    let id: Int
    var name: String
}

struct VideoArray: Decodable {
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

struct CastArray: Decodable {
    let cast: [Cast]
    // let crew: [Crew]
}

struct Cast: Decodable {
    let id: Int
    let name: String
    let character: String
    let profile_path: String?
}

struct Crew: Decodable {
    let job: String
    let name: String
    let profile_path: String?
}

struct ImageArray: Decodable {
    let backdrops: [Image]?
    let posters: [Image]?
}

struct Image: Decodable {
    let file_path: String?
}
