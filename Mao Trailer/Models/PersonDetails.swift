//
//  PersonDetails.swift
//  Mao Trailer
//
//  Created by Roger Florat on 30/07/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import Foundation

struct PersonDetails: Decodable {
    let id: Int
    let name: String
    let birthday: String?
    let biography: String
    let images: Profiles?
    let tv_credits: TVCredits?
    var movie_credits: MovieCredits?
    let profile_path: String?
    let place_of_birth: String?
    let known_for_department: String
    
    init() {
        id = 0
        name = ""
        birthday = ""
        biography = ""
        images = Profiles()
        tv_credits = TVCredits()
        movie_credits = MovieCredits()
        profile_path = ""
        place_of_birth = ""
        known_for_department = ""
    }
    
    func getFilmography() -> [Movie] {
        
        let credits = (movie_credits?.cast.filter{ $0.poster_path != nil || $0.backdrop_path != nil })!
        
        return credits.sorted { Date.compareDates( $0.release_date ?? "" , $1.release_date ?? "") }
    }
    
    func getTVShows() -> [TVShow] {
        
        let credits = (tv_credits?.cast.filter{ $0.poster_path != nil || $0.backdrop_path != nil })!
        
        return credits.sorted { Date.compareDates( $0.release_date ?? "", $1.release_date ?? "") }
    }
    
    func getBirthdayAndPlace() -> String {
        
        let birthday = self.birthday != nil ? Date.getFormattedDate(string: self.birthday!) : ""
        
        let place = self.place_of_birth != nil ? "in \(self.place_of_birth!)" : ""
        
        return "\(birthday) \(place)"
    }
    
    func knownForFilmography() -> String {
        
        let credits = getFilmography().prefix(3)
        
        var knownFor = (credits.count) > 0 ? "Known for:" : ""
        
        for item in credits {
            
            let string = " \(item.title) (\(Date.getFormattedDate(string: item.release_date!,formatter: "yyyy"))),"
            
            knownFor.append(contentsOf: string )
        }
        
        return knownFor
    }
}

struct Profiles: Decodable {
    
    let profiles: [Image]
    
    init() {
        profiles = []
    }
}

struct TVCredits: Decodable {
    
    var cast: [TVShow]
    
    init() {
        cast = []
    }
}



struct MovieCredits: Decodable {
    
    var cast: [Movie]
    
    init() {
        cast = []
    }
}
