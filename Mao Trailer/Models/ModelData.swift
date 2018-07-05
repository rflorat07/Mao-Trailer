//
//  ModelData.swift
//  Mao Trailer
//
//  Created by Roger Florat on 05/07/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import Foundation


let TVShowMore: TVShow = TVShow(id: 0, title: "More", overview: "More", poster_path: "land-more", vote_average: 0.0, release_date: "2018-06-06",backdrop_path : "", original_title: "More")

let MoreMovie: Movie = Movie(id: 0, title: "More", overview: "More", poster_path: "land-more", vote_average: 0.0, release_date: "2018-06-06",backdrop_path : "", original_title: "More")


let SectionMoviesList: [SectionMovie] = [
    SectionMovie(sectionName: "Now", movieArray: [
        Movie(id: 0, title: "Stranger Things", overview: "Stranger Things", poster_path: "StrangerThings-Slide", vote_average: 8.9, release_date: "2018-06-06", backdrop_path : "", original_title: "Stranger Things"),
        
        Movie(id: 1, title: "More", overview: "Stranger Things", poster_path: "port-more", vote_average: 0.0, release_date: "2018-06-06",backdrop_path : "", original_title: "More")
        
        ]),
    
    SectionMovie(sectionName: "Popular", movieArray: [
        Movie(id: 0, title: "Stranger Things", overview: "Stranger Things", poster_path: "StrangerThings-Slide", vote_average: 8.9, release_date: "2018-06-06",backdrop_path : "", original_title: "Stranger Things"),
        Movie(id: 1, title: "More", overview: "Stranger Things", poster_path: "port-more", vote_average: 0.0, release_date: "2018-06-06", backdrop_path : "",original_title: "More")
        ])
]


let ProfileList: [Movie] = [
    Movie(id: 0, title: "Stranger Things", overview: "Stranger Things", poster_path: "StrangerThings-Slide", vote_average: 8.9, release_date: "2018-06-06",backdrop_path : "", original_title: "Stranger Things")
]
