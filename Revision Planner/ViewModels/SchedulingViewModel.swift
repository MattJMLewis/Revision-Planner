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
        
    @Published var loadingText:String = "Scheduling..."
    @Published var showUnscheduledSheet:Bool = false
    @Published var notScheduled:[Unscheduled] = []
    @Published var scheduled:Bool = false
    @Published var barHidden:Bool = true
    
    
    func setSubject(subject: Subject) {
        self.subject = subject
    }
    
    func executeScheduler()
    {
        self.loadingText = "Loading Calendar Entries"
        
        
        self.loadingText = "Initialising Scheduler"
        let scheduler = ScheduleProcessor(subject: self.subject!)
        
        if(scheduler == nil) {
            // Do something
            self.loadingText = "Error loading calendars / topics. Please delete this subject and try again."
            self.barHidden = false
        }
        else {

            self.loadingText = "Generating Naive Schedule"
            scheduler!.generateNaiveSchedule()
            
            self.loadingText = "Adjusting for Calendar Conflicts"
            scheduler!.correctNaiveSchedule()
            
            if(scheduler!.notScheduled.count > 0) {
                self.notScheduled = scheduler!.notScheduled
                self.showUnscheduledSheet = true
            }
            else {
                self.cleanUp()
            }
        }
    }
    
    func cleanUp()
    {
        SubjectStorage.shared.update(uuid: subject!.id, values: ["scheduled": true])
        scheduled = true
    }
}
