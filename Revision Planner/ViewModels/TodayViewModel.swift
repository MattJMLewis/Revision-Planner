//
//  TodayViewModel.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 27/08/2021.
//

import Foundation
import Combine
import CoreData

class TodayViewModel: ObservableObject {
    
    
    @Published var selectedPeriod: Int = 0 {
        didSet {
            if(selectedPeriod == 0) {
                currentDateRange = DateHelper.dayDateRange(date: Date())
                barTitle = "Today"
                sessionsTitle = "TODAY'S SESSIONS"

                moved = 0
            }
            else {
                currentDateRange = DateHelper.weekDateRange(date: Date())
                barTitle = "This Week"
                sessionsTitle = "THIS WEEK'S SESSIONS"

                moved = 0
            }
                        
            updateData()
        }
    }
    @Published var barTitle: String = "Today"
    @Published var sessionsTitle: String = "TODAY'S SESSIONS"
    @Published var moved: Int = 0

    @Published var currentDateRange: [Date] = DateHelper.dayDateRange(date: Date())
    @Published var uncompletedSessions: [Session] = []
    @Published var completedSessions: [Session] = []
    @Published var sessions: [Session] = []
    
    @Published var totalSessionsCount:Int = 0
    @Published var completedSessionsCount:Int = 0
    @Published var percentageComplete:Float = 0.0
    
    @Published var openSessionPage:Bool = false
    @Published var selectedSession: Session
    
    init() {
        self.selectedSession = SessionStorage.shared.fetchSome(count: 1)[0]
        updateData()
    }
    
    func updateData() {
        sessions = SessionStorage.shared.fetchByDate(startDate: currentDateRange[0], endDate: currentDateRange[1])
        uncompletedSessions = sessions.filter({$0.completed == false})
        completedSessions = sessions.filter({$0.completed == true})
        
        totalSessionsCount = sessions.count
        completedSessionsCount = completedSessions.count
        percentageComplete = Float(completedSessionsCount) / Float(totalSessionsCount)
    }
    
    func move(increment: Int) {
        if(selectedPeriod == 0) {
            // Day
            currentDateRange = DateHelper.dayDateRange(date: DateHelper.addToDate(date: currentDateRange[0], day: increment))
        }
        else {
            // Week
            currentDateRange = DateHelper.weekDateRange(date: DateHelper.addToDate(date: currentDateRange[0], day: increment))
        }
        
        if(increment < 0) {
            moved -= 1
        }
        else {
            moved += 1
        }
    }
    
    func moveForward() {

        if(selectedPeriod == 0) {
            move(increment: 1)
        }
        else {
            move(increment: 7)
        }
        
        setPageText()
        updateData()
    }
    
    func moveBackward() {
        
        if(selectedPeriod == 0) {
            move(increment: -1)
        }
        else {
            move(increment: -7)
        }
    
        setPageText()
        updateData()
    
    }
    
    func setPageText() {
        
        if(selectedPeriod == 0) {
            if(moved < -1) {
                barTitle = DateHelper.getShortDateString(date: currentDateRange[0])
                sessionsTitle = "SESSIONS ON \(barTitle.uppercased())"
            }
            else if(moved == -1) {
                barTitle = "Yesterday"
                sessionsTitle = "YESTERDAY'S SESSIONS"
            }
            else if(moved == 0) {
                barTitle = "Today"
                sessionsTitle = "TODAY'S SESSIONS"
            } else if(moved == 1) {
                barTitle = "Tomorrow"
                sessionsTitle = "TOMORROW'S SESSIONS"
            } else if(moved < 7) {
                barTitle = DateHelper.getDayFromDate(date: currentDateRange[0])
                sessionsTitle = "\(barTitle.uppercased())'S SESSIONS"
            } else {
                barTitle = DateHelper.getShortDateString(date: currentDateRange[0])
                sessionsTitle = "SESSIONS ON \(barTitle.uppercased())"
            }
            
        }
        else {
            if(moved < -1) {
                barTitle = "\(DateHelper.getShortDateString(date: currentDateRange[0])) - \(DateHelper.getShortDateString(date: currentDateRange[1]))"
                sessionsTitle = "SESSIONS ON \(barTitle.capitalized)"
            } else if(moved == -1) {
                barTitle = "Last Week"
                sessionsTitle = "LAST WEEK'S SESSIONS"
            } else if(moved == 0) {
                barTitle = "This Week"
                sessionsTitle = "THIS WEEK'S SESSIONS"
            } else if(moved == 1) {
                barTitle = "Next Week"
                sessionsTitle = "NEXT WEEK'S SESSIONS"
            } else {
                barTitle = "\(DateHelper.getShortDateString(date: currentDateRange[0])) - \(DateHelper.getShortDateString(date: currentDateRange[1]))"
                sessionsTitle = "SESSIONS ON \(barTitle.capitalized)"
            }
        }
    }
}
