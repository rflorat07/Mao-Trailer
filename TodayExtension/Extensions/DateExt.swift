//
//  DateExt.swift
//  TodayExtension
//
//  Created by Roger Florat on 04/09/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import Foundation

extension Date {
    static func currentDateAsString(formatter:String = "yyyy-MM-dd") -> String {
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        
        return dateFormatter.string(from: date)
    }
}

