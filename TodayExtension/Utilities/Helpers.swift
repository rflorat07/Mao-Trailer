//
//  Helpers.swift
//  TodayExtension
//
//  Created by Roger Florat on 04/09/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import UIKit

class Helpers {
    
    static func getImagePath(urlString: String, baseUrl: String = ImageSize.baseUrl, size: String = ImageSize.medium) -> String {
        return "\(baseUrl)\(size)\(urlString)"
    }
    
}
