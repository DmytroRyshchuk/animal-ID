//
//  WorkWithDate.swift
//  BarkBarkBook
//
//  Created by Dmytro Ryshchuk on 29.08.17.
//  Copyright © 2017 Dmytro Ryshchuk. All rights reserved.
//

import Foundation

class WorkWithDate {
    
    var eventsArray = [EventsArray]()
    
    func getDate() -> [EventsArray] {
        
        return eventsArray
    }
    
    func setDate(date: String, title: String, body: String) {
        let formatter = DateFormatter()
        formatter.locale = NSLocale.current
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "dd MMMM yyyy HH:mm"
        
        let convertedStartDate = formatter.date(from: date)

        let displayHours = formatTime(format: "HH").string(from: convertedStartDate!)
        let displayMinutes = formatTime(format: "mm").string(from: convertedStartDate!)
        let displayDate = formatTime(format: "dd").string(from: convertedStartDate!)
        let displayMonth = formatTime(format: "MM").string(from: convertedStartDate!)
        let displayYear = formatTime(format: "yyyy").string(from: convertedStartDate!)
        
        let event = EventsArray(date: [Int(displayHours)!, Int(displayMinutes)!, Int(displayDate)!,
                                       Int(displayMonth)!, Int(displayYear)!],
                                title: title,
                                body: body)
        eventsArray.append(event)
    }
    
    private func formatTime(format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = NSLocale.current//Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = format
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        return formatter
    }
}
