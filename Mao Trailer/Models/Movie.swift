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

struct Cast {
    var name: String
    var imgUrl: String
    var character: String?
}

class DataMovies {
    
    let hotMovies: [Movie] = [
        Movie(id: 0, rate: 8.9, title: "Stranger Things", imgUrl: "StrangerThings-Slide", description: "Stranger Things"),
        Movie(id: 1, rate: 8.4, title: "The Walking Dead", imgUrl: "TheWalkingDead-Slide", description: "The Walking Dead"),
        Movie(id: 2, rate: 8.0, title: "The Flash", imgUrl: "TheFlash-Slide", description: "The Flash"),
        Movie(id: 3, rate: 9.5, title: "Game of Thrones", imgUrl: "GameofThrones-Slide", description: "Game of Thrones"),
        Movie(id: 4, rate: 8.7, title: "Shameless", imgUrl: "Shameless-Slide", description: "Shameless"),
        Movie(id: 5, rate: 0.0, title: "More", imgUrl: "land-more", description: "More")
    ]
    
    let nowMovies: [Movie] = [
        Movie(id: 0, rate: 8.9, title: "Narcos", imgUrl: "Narcos-Slide", description: "Narcos"),
        Movie(id: 1, rate: 7.6, title: "Top of the Lake", imgUrl: "TopLake-Slide", description: "Top of the Lake"),
        Movie(id: 2, rate: 8.5, title: "Outlander", imgUrl: "Outlander-Slide", description: "Outlander"),
        Movie(id: 3, rate: 8.9, title: "Lethal Weapon", imgUrl: "LethalWeapon-Slide", description: "Lethal Weapon"),
        Movie(id: 4, rate: 8.3, title: "Brooklyn Nine-Nine", imgUrl: "Brooklyn-Slide", description: "Brooklyn Nine-Nine"),
        Movie(id: 5, rate: 0.0, title: "More", imgUrl: "port-more", description: "More")
        
    ]
    
    let tvMovies : [Movie] = [
        
        Movie(id: 0, rate: 8.9, title: "Stranger Things", imgUrl: "StrangerThings-Slide", description: "Stranger Things"),
        Movie(id: 1, rate: 8.4, title: "The Walking Dead", imgUrl: "TheWalkingDead-Slide", description: "The Walking Dead"),
        Movie(id: 2, rate: 8.0, title: "The Flash", imgUrl: "TheFlash-Slide", description: "The Flash"),
        Movie(id: 3, rate: 9.5, title: "Game of Thrones", imgUrl: "GameofThrones-Slide", description: "Game of Thrones"),
        Movie(id: 4, rate: 8.7, title: "Shameless", imgUrl: "Shameless-Slide", description: "Shameless"),
        Movie(id: 5, rate: 0.0, title: "More", imgUrl: "land-more", description: "More")
    ]
    

    let sectionMovies: [Section] = [
        Section(sectionName: "Now", movieArray: [
            Movie(id: 0, rate: 6.6, title: "Justice League", imgUrl: "JusticeLeague-Slide", description: "Fueled by his restored faith in humanity and inspired by Superman's selfless act, Bruce Wayne enlists the help of his newfound ally, Diana Prince, to face an even greater enemy."),
            Movie(id: 1, rate: 6.4, title: "Rampage", imgUrl: "Rampage-Slide", description: "When three different animals become infected with a dangerous pathogen, a primatologist and a geneticist team up to stop them from destroying Chicago."),
            Movie(id: 2, rate: 7.5, title: "Spider-Man: Homecoming", imgUrl: "SpiderMan-Slide", description: "Peter Parker balances his life as an ordinary high school student in Queens with his superhero alter-ego Spider-Man, and finds himself on the trail of a new menace prowling the skies of New York City."),
            Movie(id: 3, rate: 7.9, title: "Thor: Ragnarok", imgUrl: "ThorRagnarok-Slide", description: "Thor is imprisoned on the planet Sakaar, and must race against time to return to Asgard and stop Ragnarök, the destruction of his world, at the hands of the powerful and ruthless villain Hela."),
            Movie(id: 4, rate: 8.1, title: "Hotel Transylvania 3: Summer Vacation", imgUrl: "HotelTransylvania-Slide", description: "Mavis surprises Dracula with a family voyage on a luxury Monster Cruise Ship so he can take a vacation from providing everyone else's vacation at the hotel. The rest of Drac's Pack cannot resist going along. But once they leave port, romance arises when Dracula meets the mysterious ship Captain, Ericka. "),
            Movie(id: 5, rate: 0.0, title: "More", imgUrl: "port-more", description: "More")
            ]),
        Section(sectionName: "Popular", movieArray: [
            Movie(id: 0, rate: 6.5, title: "Tomb Raider", imgUrl: "TombRaider-Slide", description: "Tomb Raider"),
            Movie(id: 1, rate: 7.5, title: "Spider-Man: Homecoming", imgUrl: "SpiderMan-Slide", description: "Spider-Man: Homecoming"),
            Movie(id: 2, rate: 7.5, title: "Wonder Woman", imgUrl: "WonderWoman-Slide", description: "Wonder Woman"),
            Movie(id: 2, rate: 7.9, title: "Arrival", imgUrl: "Arrival-Slide", description: "Arrival"),
            Movie(id: 3, rate: 8.9, title: "Narcos", imgUrl: "Narcos-Slide", description: "Narcos"),
            Movie(id: 5, rate: 0.0, title: "More", imgUrl: "port-more", description: "More")
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
    
}


