//
//  CalendarInterface.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 22/08/2021.
//

import Foundation
import EventKit

class CalendarInterface {
    
    static var shared = CalendarInterface()
  
    let eventStore:EKEventStore = EKEventStore()
    
    func reloadEventStore()
    {
        // This function should be run after permission is granted to user...
        CalendarInterface.shared = CalendarInterface()
    }
    
    
    func getCalendars() -> [EKCalendar] {
        return self.eventStore.calendars(for: .event)
    }
    
    func getCalendarByTitle(title: String) -> EKCalendar? {
        let calendars = self.getCalendars()
        
        do {
            return calendars.filter({$0.title == title})[0]
        } catch {
            return nil
        }
    }
    
    func createCalendar(title: String) -> EKCalendar? {
        let calendar = EKCalendar(for: .event, eventStore: self.eventStore)
        
        calendar.title = title
        
        guard let source = self.bestPossibleEKSource() else {
            return nil
        }
        
        calendar.source = source
        
        do {
            try self.eventStore.saveCalendar(calendar, commit: true)
        } catch {
            return nil
        }
    
        return calendar
    }
    
    func deleteCalendar(title: String) -> Bool {
        
        let calendars = self.getCalendars()
        
        do {
            let calendar = calendars.filter({$0.title == title})[0]
            try self.eventStore.removeCalendar(calendar, commit: true)
        } catch {
            return false
        }
        
        return true
        
    }
    
    func createEvent(event: EKEvent) -> Bool {
        
        do {
            try self.eventStore.save(event, span: .thisEvent)
        } catch {
            return false
        }
        
        return true
    }
    
    func deleteEvent(event: EKEvent) -> Bool {
        do {
            try self.eventStore.remove(event, span: .thisEvent, commit: true)
        } catch {
            print(error)
            return false
        }
        
        return true
    }
    
    private func bestPossibleEKSource() -> EKSource? {
        let `default` = self.eventStore.defaultCalendarForNewEvents?.source
        let iCloud = self.eventStore.sources.first(where: { $0.title == "iCloud" }) // this is fragile, user can rename the source
        let local = self.eventStore.sources.first(where: { $0.sourceType == .local })

        return `default` ?? iCloud ?? local
    }
    
}
