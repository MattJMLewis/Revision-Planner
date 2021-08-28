//
//  SubjectViewModel.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 19/08/2021.
//

import Foundation
import Foundation
import Combine

class SubjectDetailViewModel: ObservableObject {
    
    @Published var showWeekEmpty:Bool = false
    @Published var displayMode:Int = 0 {
        didSet {
            if(displayMode == 0 && totalSessionsThisWeek == 0) {
                displayMode = 1
                showWeekEmpty = true
            }
        }
    }
    
    @Published var percentageCompleteThisWeek:Float = 0.0
    @Published var totalSessionsThisWeek:Int = 0
    @Published var completedSessionsThisWeek:Int = 0
    
    @Published var percentageComplete:Float = 0.0
    @Published var totalSessions:Int = 1
    @Published var completedSessions:Int = 0
    
    @Published var thisWeeksSessions:[Session] = []
    @Published var upcomingSessions:[Session] = []
    
    @Published var openSessionPage:Bool = false
    @Published var selectedSession: Session
    
    private var subject:Subject
    
    
    init(subject: Subject) {
        self.subject = subject
        
        
        // Quick fix
        let allSessions = SessionStorage.shared.fetchBySubject(subject: subject)
        self.selectedSession = allSessions[0]
        
        
        performCalculations()
        
    }
    
    func performCalculations()
    {
        let today = Date()
        let nextWeek = DateHelper.addToDate(date: today, day: 7)
        
        thisWeeksSessions = SessionStorage.shared.fetchBySubjectAndDates(subject: subject, startDate: today, endDate: nextWeek)
        let allSessions = SessionStorage.shared.fetchBySubject(subject: subject)
        
        
        totalSessionsThisWeek = thisWeeksSessions.count
        totalSessions = allSessions.count
        
        if(totalSessionsThisWeek == 0) {
            displayMode = 1
            upcomingSessions = SessionStorage.shared.fetchSome(count: 4)
            
            return
            
        }
        
        
        completedSessionsThisWeek = thisWeeksSessions.filter({$0.completed == true}).count
        completedSessions = allSessions.filter({$0.completed == true}).count
        
        percentageCompleteThisWeek = Float(completedSessionsThisWeek) / Float(totalSessionsThisWeek)
        percentageComplete = Float(completedSessions) / Float(totalSessions)

    }
}
