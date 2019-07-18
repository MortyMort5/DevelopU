//
//  DateHelper.swift
//  DevelopU
//
//  Created by Sterling Mortensen on 4/4/19.
//  Copyright © 2019 GitSwifty. All rights reserved.
//

import Foundation

class DateHelper {
    
    static func dayOfWeekLetter(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.string(from: date)
    }
    
    static func convertDateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = Constant.dateFormatKey
        let myString = formatter.string(from: date)
        return myString
    }
    
    static func convertStringToDate(stringDate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = Constant.dateFormatKey
        if let date = dateFormatter.date(from: stringDate) {
            return date
        }
        return Date()
    }
    
    static func compareDateToToday(timestamp: Date) -> Bool {
        if Calendar.current.isDate(timestamp, inSameDayAs:Date()) {
            return true
        }
        return false
    }
}
