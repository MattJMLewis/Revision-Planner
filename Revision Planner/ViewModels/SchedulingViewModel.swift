//
//  SchedulingViewModel.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 27/03/2021.
//

import Foundation
import EventKit

class SchedulingViewModel: ObservableObject {

    var subject: Subject?
        
    @Published var loadingText:String = "Starting"
    @Published var showUnscheduledSheet:Bool = false
    @Published var notScheduled:[Unscheduled] = []
    @Published var scheduled:Bool = false
    
    
    func setSubject(subject: Subject) {
        self.subject = subject
    }
    
    func executeScheduler()
    {
        self.loadingText = "Loading Calendar Entries"
        
        CalendarInterface.shared.eventStore.requestAccess(to: .event) { (granted, error) in
            if granted {
                DispatchQueue.main.async {
 
                    self.loadingText = "Initialising Scheduler"
                    let scheduler = ScheduleProcessor(subject: self.subject!)
    
                    self.loadingText = "Generating Naive Schedule"
                    scheduler.generateNaiveSchedule()
                    
                    self.loadingText = "Adjusting for Calendar Conflicts"
                    scheduler.correctNaiveSchedule()
                    
                    if(scheduler.notScheduled.count > 0) {
                        self.notScheduled = scheduler.notScheduled
                        self.showUnscheduledSheet = true
                    }
                    else {
                        self.cleanUp()
                    }

                }
            }
            else
            {
                print("No calendars")
            }
        }
    }
    
    func cleanUp()
    {
        SubjectStorage.shared.update(uuid: subject!.id, values: ["scheduled": true])
        scheduled = true
    }
}
