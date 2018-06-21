//
//  Movie.swift
//  Mao Trailer
//
//  Created by Roger Florat on 21/06/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import Foundation

struct Movie {
    var id: Int
    var rate: Double?
    var title:String?
    var imgUrl: String
    var description: String?
}


struct Section {
    var sectionName: String
    var movieArray: [Movie]
}


class DataMovies {
    
    let hotMovies: [Movie] = [
        Movie(id: 0, rate: 0.0, title: "Mao Trailer", imgUrl: "HotView-Slide", description: "Mao Trailer"),
        Movie(id: 1, rate: 0.0, title: "TopView-Slide", imgUrl: "TopView-Slide", description: "TopView-Slide"),
        Movie(id: 2, rate: 0.0, title: "TVPopular-Slide", imgUrl: "TVPopular-Slide", description: "TVPopular-Slide"),
        Movie(id: 3, rate: 0.0, title: "Mao Trailer", imgUrl: "HotFlash-Slide", description: "HotFlash-Slider")
    ]
    
    let nowMovies: [Movie] = [
        Movie(id: 0, rate: 6.6, title: "Justice League", imgUrl: "JusticeLeague-Slide", description: "Justice League"),
        Movie(id: 1, rate: 6.4, title: "Rampage", imgUrl: "Rampage-Slide", description: "Rampage"),
        Movie(id: 2, rate: 7.5, title: "Spider-Man: Homecoming", imgUrl: "SpiderMan-Slide", description: "Spider-Man: Homecoming"),
        Movie(id: 3, rate: 7.9, title: "Thor: Ragnarok", imgUrl: "ThorRagnarok-Slide", description: "Thor: Ragnarok"),
        Movie(id: 4, rate: 8.1, title: "Hotel Transylvania 3: Summer Vacation", imgUrl: "HotelTransylvania-Slide", description: "Hotel Transylvania 3: Summer Vacation")
    ]
    
    let popularMovies: [Movie] =  [
        Movie(id: 0, rate: 6.5, title: "Tomb Raider", imgUrl: "TombRaider-Slide", description: "Tomb Raider"),
        Movie(id: 1, rate: 7.5, title: "Spider-Man: Homecoming", imgUrl: "SpiderMan-Slide", description: "Spider-Man: Homecoming"),
        Movie(id: 2, rate: 7.9, title: "Arrival", imgUrl: "Arrival-Slide", description: "Arrival"),
        Movie(id: 3, rate: 8.9, title: "Narcos", imgUrl: "Narcos-Slide", description: "Narcos")
    ]
    
    let sectionMovies: [Section] = [
        Section(sectionName: "Now", movieArray: [
            Movie(id: 0, rate: 6.6, title: "Justice League", imgUrl: "JusticeLeague-Slide", description: "Justice League"),
            Movie(id: 1, rate: 6.4, title: "Rampage", imgUrl: "Rampage-Slide", description: "Rampage"),
            Movie(id: 2, rate: 7.5, title: "Spider-Man: Homecoming", imgUrl: "SpiderMan-Slide", description: "Spider-Man: Homecoming"),
            Movie(id: 3, rate: 7.9, title: "Thor: Ragnarok", imgUrl: "ThorRagnarok-Slide", description: "Thor: Ragnarok"),
            Movie(id: 4, rate: 8.1, title: "Hotel Transylvania 3: Summer Vacation", imgUrl: "HotelTransylvania-Slide", description: "Hotel Transylvania 3: Summer Vacation")
            ]),
        Section(sectionName: "Popular", movieArray: [
            Movie(id: 0, rate: 6.5, title: "Tomb Raider", imgUrl: "TombRaider-Slide", description: "Tomb Raider"),
            Movie(id: 1, rate: 7.5, title: "Spider-Man: Homecoming", imgUrl: "SpiderMan-Slide", description: "Spider-Man: Homecoming"),
            Movie(id: 2, rate: 7.5, title: "Wonder Woman", imgUrl: "WonderWoman-Slide", description: "Wonder Woman"),
            Movie(id: 2, rate: 7.9, title: "Arrival", imgUrl: "Arrival-Slide", description: "Arrival"),
            Movie(id: 3, rate: 8.9, title: "Narcos", imgUrl: "Narcos-Slide", description: "Narcos")
            ])
    ]
    
}


