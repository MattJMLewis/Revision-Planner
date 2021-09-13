//
//  SessionViewModel.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 25/08/2021.
//


import Foundation
import Combine
import UserNotifications

class SessionViewModel: ObservableObject {

    private var session: Session

    
    @Published var timer: Publishers.Autoconnect<Timer.TimerPublisher>? = nil
    
    @Published var totalTime:Double
    @Published var timeRemainingSeconds:Int
    @Published var timeRemaining:Double
    @Published var timeRemainingPerc:Double
    @Published var sessionCompleted:Bool
    
    var finishTime:Date?
    
    
    init(session: Session) {
        self.session = session
        
        self.sessionCompleted = session.completed
        
        let time = Double(session.endDate - session.startDate)
        
        self.timeRemaining = time
        self.timeRemainingSeconds = Int(time)
        self.totalTime = time
        
        self.timeRemainingPerc = 1.0
    }
    
    func startTimer() {
        self.timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
        self.timeRemainingPerc = 1.0

    }
    
    func stopTimer() {
        self.timer?.upstream.connect().cancel()
        self.timer = nil
    }
    
    func resetTimer() {
        self.stopTimer()
        self.incompleteSession()
        
        self.timeRemainingSeconds = Int(self.totalTime)
        self.timeRemaining = self.totalTime
        self.timeRemainingPerc = 1.0
        
    }
    
    func completeSession()
    {
        self.stopTimer()
        
        SessionStorage.shared.update(uuid: session.id, values: ["completed": true])
        self.sessionCompleted = true
    }
    
    func incompleteSession()
    {
        SessionStorage.shared.update(uuid: session.id, values: ["completed": false])
        self.sessionCompleted = false
    }
    
    func movingToBackground()
    {
        if(self.timer != nil) {
            self.finishTime = DateHelper.addToDate(date: Date(), second: self.timeRemainingSeconds)
            self.addNotification(secondsAway: self.timeRemaining)
        }
    }
    
    func movingToForeground()
    {
        if let time = self.finishTime {
            
            let timeLeft = time - Date()
            
            if(timeLeft <= 0) {
                self.timeRemaining = 0
                self.timeRemainingSeconds = 0
                
                self.completeSession()
            }
            else {
                self.timeRemaining = time - Date()
                self.timeRemainingSeconds = Int(self.timeRemaining)
                self.removeNotification()
            }
        }
    }
    
    func addNotification(secondsAway: Double)
    {
        let content = UNMutableNotificationContent()
        content.title = "Session Complete"
        content.subtitle = "Well Done! You've completed a session for \(self.session.topic.name)!"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: secondsAway, repeats: false)
        let request = UNNotificationRequest(identifier: self.session.id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        
    }
    
    func removeNotification()
    {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [String(self.session.id.uuidString)])
    }
}
