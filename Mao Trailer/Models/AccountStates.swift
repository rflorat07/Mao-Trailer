//
//  AccountStates.swift
//  Mao Trailer
//
//  Created by Roger Florat on 23/08/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import Foundation

struct AccountStates: Decodable {
    let id: Int
    let favorite: Bool?
    let watchlist: Bool?
    var rated: RatedValue?
}

struct RatedValue: Decodable {
    
    var value: Bool
    var ratedValue: Float?
    
    enum CodingKeys: String, CodingKey {
        case value
    }
    
    init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        
        if let value = (try container?.decodeIfPresent(Float.self, forKey: .value)) {
            self.value = true
            self.ratedValue = value
        
        } else {
            self.value = false
            self.ratedValue = 0.0
        }
        
        return
    }
}
