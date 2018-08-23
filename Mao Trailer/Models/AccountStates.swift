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
    let rated: RatedValue?
}

struct RatedValue: Decodable {
    
    var value: Bool
    
    enum CodingKeys: String, CodingKey {
        case value
    }
    
    init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        
        if (try container?.decodeIfPresent(Int.self, forKey: .value)) != nil {
            self.value = true
        } else {
            self.value = false
        }
        
        return
    }
}
