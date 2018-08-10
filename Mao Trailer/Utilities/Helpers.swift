//
//  Helpers.swift
//  Mao Trailer
//
//  Created by Roger Florat on 10/08/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import Foundation

class Helpers {
    
    static func downloadedFrom(urlString: String, baseUrl: String = ImageSize.baseUrl, size: String = ImageSize.medium) -> String {
        return "\(baseUrl)\(size)\(urlString)"
    }
    
    static func downloadedAvatarFrom(urlString: String, baseUrl: String = Gravatar.baseUrl, size: String = Gravatar.thumbnails) -> String {
        
        return "\(baseUrl)\(urlString)\(size)"
    }
    
}
