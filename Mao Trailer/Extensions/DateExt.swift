//
//  DateExt.swift
//  Mao Trailer
//
//  Created by Roger Florat on 27/07/18.
//  Copyright © 2018 Roger Florat. All rights reserved.
//

import Foundation

extension Date {
    
    static func getFormattedDate(string: String , formatter:String = "dd MMMM yyyy" ) -> String {
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd" // This formate is input formated
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = formatter // Output Formated
        
        guard let date: Date = dateFormatterGet.date(from: string) else { return "" }
        
        return dateFormatterPrint.string(from: date)
    }
    
    static func getFormattedTime(minute: Double) -> String{
        
        let second = (minute * 60)
        let formatter = DateComponentsFormatter()
        
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute, .second]
        
        guard let formattedString = formatter.string(from: second) else { return "" }
        
        return formattedString
    }
    
    static func compareDates(_ first: String, _ second: String) -> Bool {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if !first.isEmpty && !second.isEmpty {
            
            let firstDate = formatter.date(from: first)
            let secondDate = formatter.date(from: second)
            
            if firstDate?.compare(secondDate!) == .orderedDescending {
                return true
            }
        }
        
        return false
    }
}
