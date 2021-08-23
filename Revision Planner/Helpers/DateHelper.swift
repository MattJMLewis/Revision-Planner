//
//  DateHelper.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 22/08/2021.
//

import Foundation


class DateHelper {
    
    static func addToDate(date: Date, month: Int = 0, day: Int = 0, hour: Int = 0, minute: Int = 0, second: Int = 0) -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = second
        
        return Calendar.current.date(byAdding: dateComponents,to: date)!
    }
    
    static func setTimeOnDate(date: Date, hour: Int = 0, minute: Int = 0, second: Int = 0) -> Date {
        return Calendar.current.date(bySettingHour: hour, minute: minute, second: second, of: date)!
    }
    
    static func copyTimeToOtherDate(timeDate: Date, targetDate: Date) -> Date {
        
        let utc = TimeZone(abbreviation: "UTC")
        let calendar = Calendar.current
        
        let timeDateComponents = calendar.dateComponents(in: utc!, from: timeDate)
        let targetDateComponents = calendar.dateComponents(in: utc!, from: targetDate)
        
        let newDate = DateComponents(timeZone:utc, year: targetDateComponents.year, month: targetDateComponents.month, day: targetDateComponents.day,
                                     hour: timeDateComponents.hour, minute: timeDateComponents.minute, second: timeDateComponents.second)
    
        return calendar.date(from: newDate)!
    }
    
    static func compareTimeOnly(firstDate: Date, secondDate: Date) -> Bool {
        
        let utc = TimeZone(abbreviation: "UTC")
        let calendar = Calendar.current
    
        let firstDateComponents = calendar.dateComponents(in: utc!, from: firstDate)
        let secondDateComponents = calendar.dateComponents(in: utc!, from: secondDate)
        
        if(firstDateComponents.hour! > secondDateComponents.hour!) {
            return true
        } else if(firstDateComponents.hour == secondDateComponents.hour && firstDateComponents.minute! > secondDateComponents.minute!) {
            return true
        }
        
        return false

    }
    
    static func getStringDate(date: Date) -> [String] {
        var output:[String] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLL"
        output.append(dateFormatter.string(from: date))
        
        let calendar = Calendar.current
        output.append(String(calendar.component(.day, from: date)))
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        output.append(String(format:"%d:%02d", hour, minutes))
        
        return output
        
    }
    
}
