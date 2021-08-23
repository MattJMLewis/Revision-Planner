//
//  UnscheduledCardViewModel.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 23/08/2021.
//

import Foundation
import Combine

class UnscheduledCardViewModel: ObservableObject {
    
    func overrideClash(unscheduled: Unscheduled) {
        // Here we only need to update the database as the calendar event has not been changed
        
        let session = unscheduled.session
 
        session.startDate = unscheduled.originalStartDate
        session.endDate = unscheduled.originalEndDate
        
        SessionStorage.shared.update(uuid: session.id, values: ["startDate": session.startDate, "endDate": session.endDate])
    }
    
    func deleteSession(unscheduled: Unscheduled) {
        // Here we need to delete calendar event and session
        
        let session = unscheduled.session
    
        let subjectCalendar = CalendarInterface.shared.getCalendarByTitle(title: session.topic.subject.calendarName())!
        
        let predicate = CalendarInterface.shared.eventStore.predicateForEvents(withStart: unscheduled.originalStartDate, end: unscheduled.originalEndDate, calendars: [subjectCalendar])
        
        let oldEvent = CalendarInterface.shared.eventStore.events(matching: predicate).filter{$0.title == session.name}[0]
        
        CalendarInterface.shared.deleteEvent(event: oldEvent)
        SessionStorage.shared.delete(id: session.id)
    }
    
    

}
