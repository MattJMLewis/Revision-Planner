//
//  ImportFromCalendarViewModel.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 12/03/2021.
//

import Foundation
import EventKit
import UIKit

class ImportFromCalendarViewModel: ObservableObject {
    
    private var eventStore: EKEventStore = EKEventStore()
    
    @Published var subject:Subject
    @Published var calendars: [EKCalendar] = []
    @Published var events: [EKEvent] = []
    @Published var selectedCalendar: Int = 0 {
        didSet {
            updateEvents()
        }
    }
    
    init()
    {
        self.subject = SubjectStorage.shared.fetchFirst()!
        
        self.eventStore.requestAccess(to: .event) { (granted, error) in
            if granted {
                
                DispatchQueue.main.async {
                    self.calendars = CalendarInterface.shared.getCalendars()
                }
            }
            else {
                print("Add error handling here...")
            }
        }
    }
    
    func addEvents()
    {
        for event in events {
            TopicStorage.shared.add(name: event.title, startDate: event.startDate, endDate: event.endDate, subject: subject)
        }
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)

    }
    
    func updateEvents()
    {
        let currentCalendar = self.calendars[selectedCalendar]
        let predicate = self.eventStore.predicateForEvents(withStart: self.subject.startDate, end: self.subject.endDate, calendars: [currentCalendar])
        
        self.events = eventStore.events(matching: predicate)
    }
}
