//
//  Cast.swift
//  Mao Trailer
//
//  Created by Roger Florat on 04/07/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import Foundation

struct Cast {
    var name: String
    var imgUrl: String
    var character: String?
}

let FullCastList: [Cast] = [
    Cast(name: "Zack Snyder", imgUrl: "ZackSnyder-cast", character: ""),
    Cast(name: "Ben Affleck", imgUrl: "BenAffleck-cast", character: ""),
    Cast(name: "Henry Cavill", imgUrl: "HenryCavill-cast", character: ""),
    Cast(name: "Gal Gadot", imgUrl: "GalGadot-cast", character: ""),
    Cast(name: "Amy Adams", imgUrl: "AmyAdams-cast", character: ""),
    Cast(name: "Ray Fisher", imgUrl: "RayFisher-cast", character: ""),
    Cast(name: "Jason Momoa", imgUrl: "JasonMomoa-cast", character: ""),
]
