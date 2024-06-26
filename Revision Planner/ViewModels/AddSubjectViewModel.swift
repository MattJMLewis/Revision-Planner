//
//  AddViewModel.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 18/02/2021.
//

import Foundation
import Combine
import EventKit

class AddSubjectViewModel: ObservableObject {
    
    @Published var name:String = ""
    
    @Published var startDate:Date = Date()
    @Published var endDate:Date = DateHelper.addToDate(date: Date(), month: 1)
    
    @Published var startTime:Date = DateHelper.setTimeOnDate(date: Date(), hour: 9)
    @Published var endTime:Date = DateHelper.setTimeOnDate(date: Date(), hour: 17)
    
    @Published var sessionLength:String = "30" {
        didSet {
            let filtered = sessionLength.filter { $0.isNumber }
            
            if sessionLength != filtered {
                sessionLength = filtered
            }
        }
    }
    
    @Published var dateRanges:[DateRange] = []
    @Published var weekdays:[Weekday] = [
        Weekday(text: "M", ordinal: 2),
        Weekday(text: "T", ordinal: 3),
        Weekday(text: "W", ordinal: 4),
        Weekday(text: "T", ordinal: 5),
        Weekday(text: "F", ordinal: 6),
        Weekday(enabled: true, text: "S", ordinal: 7),
        Weekday(enabled: true, text: "S", ordinal: 1),
    ]
    @Published var days:[Date] = []
    
    
    @Published var formErrors:String = ""
    @Published var showAlert:Bool = false
    @Published var openAddTopicPage:Bool = false
   
    // Leave this empty for now, will fill later
    @Published var subject:Subject = Subject()
    
    func add()
    {
        if self.verifyData() {

            var excludedStartTimes: [Date] = []
            var excludedEndTimes: [Date] = []
            
            for dateRange in dateRanges
            {
                excludedStartTimes.append(dateRange.startDate)
                excludedEndTimes.append(dateRange.endDate)
            }
            
            var excludedWeekDays: [Int] = []
            
            for weekday in weekdays {
                excludedWeekDays.append(weekday.ordinal)
            }
            
            self.subject = SubjectStorage.shared.add(name: name, progress: 0.0, startDate: startDate, endDate: endDate, startTime: startTime, endTime: endTime, sessionLength: Int(sessionLength)!, excludedStartTimes: excludedStartTimes, excludedEndTimes: excludedEndTimes, excludedDays: days, excludedWeekdays: excludedWeekDays)
            
            // We need to add the date ranges to a calendar
            let calendar = CalendarInterface.shared.createCalendar(title: (self.subject.calendarName()))
            
            for dateRange in dateRanges {

                let event = EKEvent(eventStore: CalendarInterface.shared.eventStore)
                event.title = "Excluded Time"
                event.startDate = DateHelper.copyTimeToOtherDate(timeDate: dateRange.startDate, targetDate: self.subject.startDate)
                event.endDate = DateHelper.copyTimeToOtherDate(timeDate: dateRange.endDate, targetDate: self.subject.startDate)
                event.notes = "This event was automatically generated by `Revision Planner`. Please do not delete it"
                event.calendar = calendar
                
                let recurrenceRule = EKRecurrenceRule(
                    recurrenceWith: .daily,
                    interval: 1,
                    end: EKRecurrenceEnd.init(end: subject.endDate)
                )
                
                event.recurrenceRules = [recurrenceRule]

                CalendarInterface.shared.createEvent(event: event)  // Error, do something

            }
            
            for day in days {
                
                let event = EKEvent(eventStore: CalendarInterface.shared.eventStore)
                event.title = "Excluded Day"
                event.startDate = DateHelper.setTimeOnDate(date: day, hour: 0, minute: 0, second: 0)
                event.endDate = DateHelper.setTimeOnDate(date: day, hour: 23, minute: 59, second: 59)
                event.notes = "This event was automatically generated by `Revision Planner`. Please do not delete it"
                event.isAllDay = false
                event.calendar = calendar
                
                CalendarInterface.shared.createEvent(event: event)
            }
            
            for weekday in weekdays.filter({$0.enabled == true}) {
 
                let components = DateComponents(weekday: weekday.ordinal)
                let nextOccurrence = Calendar.current.nextDate(after: subject.startDate, matching: components, matchingPolicy: .nextTime)!
                

                
                let event = EKEvent(eventStore: CalendarInterface.shared.eventStore)
                event.title = "Excluded Weekday"
                event.startDate = DateHelper.setTimeOnDate(date: nextOccurrence, hour: 0, minute: 0, second: 0)
                event.endDate = DateHelper.setTimeOnDate(date: nextOccurrence, hour: 23, minute: 59, second: 59)
                event.notes = "This event was automatically generated by `Revision Planner`. Please do not delete it"
                event.calendar = calendar
                
                
                let recurrenceDay = EKRecurrenceDayOfWeek(dayOfTheWeek: EKWeekday(rawValue: weekday.ordinal)!, weekNumber: 0)
               
                let reccurenceRule = EKRecurrenceRule(
                    recurrenceWith: .weekly,
                    interval: 1,
                    daysOfTheWeek: [recurrenceDay],
                    daysOfTheMonth: nil,
                    monthsOfTheYear: nil,
                    weeksOfTheYear: nil,
                    daysOfTheYear: nil,
                    setPositions: nil,
                    end: EKRecurrenceEnd.init(end: subject.endDate)
                )
                
                event.recurrenceRules = [reccurenceRule]
                
                CalendarInterface.shared.createEvent(event: event)
            }
            
            openAddTopicPage = true
                
        }
    }
    
    func deleteOldSubject()
    {
        if(name != "") {
            let subject = SubjectStorage.shared.fetchFirst()
            var calName = subject?.calendarName()
            
            CalendarInterface.shared.deleteCalendar(title: calName!)
            SubjectStorage.shared.deleteFirst()
            
            name = ""
        }
    }
    
    func addTimeRange()
    {
        
        dateRanges.append(DateRange(startDate: DateHelper.setTimeOnDate(date: Date(), hour: 12 + dateRanges.count), endDate: DateHelper.setTimeOnDate(date: Date(), hour: 13 + dateRanges.count)))
    }
    
    func addDate() {
        days.append(Date())
    }
    
    func deleteDate(index: Int) {
        days.remove(at: index)
    }
    
    func deleteTimeRange(index: Int)
    {
        dateRanges.remove(at: index)
    }
    
    func weekdayTapped(weekday: Weekday) {
        let day = weekdays.firstIndex(of: weekday)!
        var newDay = weekdays[day]
        newDay.enabled = !newDay.enabled
        weekdays[day] = newDay
        
    }
    
    
    func verifyData() -> Bool
    {
        
        // Need to check excluded time doesn't overlap end of day
         
        var errors:[String]  = []
        // Make sure filled in
        if name.trimmingCharacters(in: .whitespaces) .isEmpty {
            errors.append("The name field cannot be empty")
        }
        
        if startDate > endDate
        {
            errors.append("The start date cannot be later than the end date")
        }
    
        if startTime > endTime
        {
            errors.append("The start time cannot be later than the end time")
        }
        
        if !dateRanges.isEmpty {
            let invalidRanges = dateRanges.filter({ $0.startDate > $0.endDate || $0.startDate == $0.endDate })
            
            if !invalidRanges.isEmpty
            {
                errors.append("The first time in a set of excluded times must be earlier than the second time")
            }
            
            var duplicateDates = false
            var datesOverlap = false
            
           
            for dateRange in dateRanges {
                let duplicates = dateRanges.filter({$0.startDate == dateRange.startDate && $0.endDate == dateRange.endDate})
                let overlaps = dateRanges.filter({($0.startDate...$0.endDate).overlaps(dateRange.startDate ... dateRange.endDate) == true })

                
                if(overlaps.count > 1) {
                    datesOverlap = true
                }
                
                if(duplicates.count > 1) {
                    duplicateDates = true
                }
            }
            
            
            if(duplicateDates) {
                errors.append("You cannot have duplicate excluded times")
            }
            
            if(datesOverlap) {
                errors.append("You cannot have overlapping excluded times")
            }
            
        }
        
        if(weekdays.filter{$0.enabled == true}.count == 7) {
            errors.append("You cannot exclude every day of the week.")
        }
        
        
        if(!days.isEmpty) {
            let invalidDays = days.filter({$0 < startDate || $0 > endDate})
            print(invalidDays)
            
            if(!invalidDays.isEmpty) {
                errors.append("The chosen days must be between the start and end days of the subject.")
            
            }
            
            var duplicateDays = false
            
            for day in days {
                let duplicates = days.filter({DateHelper.getStringDate(date: $0) == DateHelper.getStringDate(date: day)})
                
                if(duplicates.count > 1) {
                    duplicateDays = true
                }
            }
            
            if(duplicateDays) {
                errors.append("You cannot have duplicate excluded days.")
            }
        }
        
        // Cannot have invalid data to do this step
        if errors.isEmpty {
            if sessionLength.isEmpty {
                errors.append("The session length field cannot be empty")
            }
            else {
                // Time avaiable in day to revise
                var delta = endTime - startTime
                
                for timeRange in dateRanges {
                    delta = delta - (timeRange.endDate - timeRange.startDate)
                }
            
                delta = delta - Double(sessionLength)! * 60
                
                if(delta <= 0)
                {
                    errors.append("The start time, end time, excluded times and session length do not provide enough time for a single session to occur in a day.")
                }
            }
        }
        
        if errors.isEmpty {
            return true
        }
        else
        {
            formErrors = errors.joined(separator: "\n")
            showAlert = true
            return false
        }
    }
}
