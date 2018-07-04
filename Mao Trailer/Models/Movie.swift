//
//  Movie.swift
//  Mao Trailer
//
//  Created by Roger Florat on 21/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import Foundation


struct Movie: Decodable {
    let id: Int
    let title: String
    let overview: String
    let poster_path: String
    let vote_average: Double
    let release_date: String
    let backdrop_path : String
    let original_title : String
}

struct MovieList: Decodable {
    let results: [Movie]
}

struct Section {
    var sectionName: String
    var movieArray: [Movie]
}

struct Cast {
    var name: String
    var imgUrl: String
    var character: String?
}

struct Walkthrough {
    var title: String
    var imgUrl: String
    var description: String
}

class DataMovies {
    
    let walkthrough: [Walkthrough] = [
        Walkthrough(title: "Get the first", imgUrl: "Walkthrough-1", description: "Movie &TV information"),
        Walkthrough(title: "Know the movie", imgUrl: "Walkthrough-2", description: "is not worth Watching"),
        Walkthrough(title: "Real-time", imgUrl: "Walkthrough-3", description: "updates movie Trailer")
    ]
    
    let hotMovies: [Movie] = [
        
        Movie(id: 0, title: "Stranger Things", overview: "Stranger Things", poster_path: "StrangerThings-Slide", vote_average: 8.9, release_date: "2018-06-06",backdrop_path : "", original_title: "Stranger Things"),
        
        Movie(id: 1, title: "More", overview: "Stranger Things", poster_path: "land-more", vote_average: 0.0, release_date: "2018-06-06",backdrop_path : "", original_title: "More")
        
    ]
    
    let nowMovies: [Movie] = [
        Movie(id: 0, title: "Stranger Things", overview: "Stranger Things", poster_path: "StrangerThings-Slide", vote_average: 8.9, release_date: "2018-06-06",backdrop_path : "", original_title: "Stranger Things"),
        
        Movie(id: 1, title: "More", overview: "Stranger Things", poster_path: "port-more", vote_average: 0.0, release_date: "2018-06-06",backdrop_path : "", original_title: "More")
    ]
    
    let tvMovies : [Movie] = [
        
        Movie(id: 0, title: "Stranger Things", overview: "Stranger Things", poster_path: "StrangerThings-Slide", vote_average: 8.9, release_date: "2018-06-06",backdrop_path : "", original_title: "Stranger Things"),
        
        Movie(id: 1, title: "More", overview: "Stranger Things", poster_path: "land-more", vote_average: 0.0, release_date: "2018-06-06", backdrop_path : "",original_title: "More")
        
    ]
    
    let sectionMovies: [Section] = [
        Section(sectionName: "Now", movieArray: [
            Movie(id: 0, title: "Stranger Things", overview: "Stranger Things", poster_path: "StrangerThings-Slide", vote_average: 8.9, release_date: "2018-06-06", backdrop_path : "", original_title: "Stranger Things"),
            
            Movie(id: 1, title: "More", overview: "Stranger Things", poster_path: "port-more", vote_average: 0.0, release_date: "2018-06-06",backdrop_path : "", original_title: "More")
            
            
            ]),
        Section(sectionName: "Popular", movieArray: [
            Movie(id: 0, title: "Stranger Things", overview: "Stranger Things", poster_path: "StrangerThings-Slide", vote_average: 8.9, release_date: "2018-06-06",backdrop_path : "", original_title: "Stranger Things"),
            Movie(id: 1, title: "More", overview: "Stranger Things", poster_path: "port-more", vote_average: 0.0, release_date: "2018-06-06", backdrop_path : "",original_title: "More")
            ])
    ]
    
    let fullCast: [Cast] = [
        Cast(name: "Zack Snyder", imgUrl: "ZackSnyder-cast", character: ""),
        Cast(name: "Ben Affleck", imgUrl: "BenAffleck-cast", character: ""),
        Cast(name: "Henry Cavill", imgUrl: "HenryCavill-cast", character: ""),
        Cast(name: "Gal Gadot", imgUrl: "GalGadot-cast", character: ""),
        Cast(name: "Amy Adams", imgUrl: "AmyAdams-cast", character: ""),
        Cast(name: "Ray Fisher", imgUrl: "RayFisher-cast", character: ""),
        Cast(name: "Jason Momoa", imgUrl: "JasonMomoa-cast", character: ""),
        ]
    
    let profileList: [Movie] = [
        Movie(id: 0, title: "Stranger Things", overview: "Stranger Things", poster_path: "StrangerThings-Slide", vote_average: 8.9, release_date: "2018-06-06",backdrop_path : "", original_title: "Stranger Things")
    ]
    
    
}


