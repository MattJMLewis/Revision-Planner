//
//  SessionView.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 25/08/2021.
//

import SwiftUI
import CoreData



struct OptionalSessionView: View {
    
    var session: Session?
    
    init(session: Session?) {
        self.session = session
    }
    
    var body: some View {
        
        if(session != nil) {
            SessionView(session: session!)
        }
        else {
            Text("No session provided.")
        }
    }
    
}

struct SessionView: View {

    
    @ObservedObject private var viewModel: SessionViewModel
    
    var session: Session
    
    init(session: Session) {
        self.session = session
        self.viewModel = SessionViewModel(session: session)
    }
    
    var body: some View {
        VStack {
            List {
                Section(header:
                    VStack(alignment: .center) {
                    
                        Spacer()
                        HStack {
                            Spacer()
                        
                            if(viewModel.sessionCompleted) {
                                
                                CircularProgressView(progress: 1, progressText: "Completed", color: Color.green)
                                    .animation(.linear)
                                    .frame(width: 200, height: 200)
                            }
                            else {
                                if(viewModel.timer == nil) {
                                    CircularProgressView(
                                        progress: viewModel.timeRemainingPerc,
                                        progressText: DateHelper.secondsToHoursMinutesSeconds(seconds: viewModel.timeRemainingSeconds)
                                    )
                                    .animation(.linear)
                                    .frame(width: 200, height: 200)
         
                                }
                                else {
                                    CircularProgressView(progress: viewModel.timeRemainingPerc, progressText: DateHelper.secondsToHoursMinutesSeconds(seconds: viewModel.timeRemainingSeconds))
                                        .animation(.linear)
                                        .frame(width: 200, height: 200)
                                        .onReceive(viewModel.timer!, perform: { _ in
                                            
                                            if(viewModel.timeRemaining <= 0) {
                                                viewModel.completeSession()
                                            }
                                            else {
                                                viewModel.timeRemaining -= 0.2
                                                viewModel.timeRemainingSeconds = Int(viewModel.timeRemaining.rounded(.up))
                                                viewModel.timeRemainingPerc = viewModel.timeRemaining / viewModel.totalTime
                                            }
                                        })
                                }
                            }
                            
                            Spacer()
                        }
                        
                        Spacer()
                        Spacer()
                        Spacer()
                        VStack {
                            HStack(spacing: 90) {
                                Button(action: { viewModel.startTimer() }) {
                                    Text("Start")
                                }.disabled(viewModel.timer != nil || viewModel.timeRemaining <= 0 || viewModel.sessionCompleted == true)
                                
                                
                                Button(action: { viewModel.resetTimer() }) {
                                    Text("Reset")
                                }
                                
                                Button(action: { viewModel.stopTimer() }) {
                                    Text("Stop")
                                }.disabled(viewModel.timer == nil || viewModel.timeRemaining <= 0 || viewModel.sessionCompleted == true)
  
                            }
                        }
                        Spacer()
                    }
                )
                {
                }
                
                
                Section(header: Text("General")) {
                    ListItemView(image: "info.circle", textLeft: "Name", textRight: session.name)
                    ListItemView(image: "calendar", textLeft: "Date", textRight: DateHelper.getShortDateString(date: session.startDate))
                    ListItemView(image: "clock", textLeft: "Start Time", textRight: DateHelper.getTimeString(date: session.startDate))
                    ListItemView(image: "clock.fill", textLeft: "End Time", textRight: DateHelper.getTimeString(date: session.endDate))
                    ListItemView(image: "checkmark.circle", textLeft: "Completed", textRight: viewModel.sessionCompleted ? "Yes": "No")
                }
                
                Section(header: Text("Topic Details")) {
                    if(session.topic.details != nil) {
                        Text(session.topic.details!)
                    }
                    ListItemView(image: "calendar", textLeft: "Topic Date", textRight: DateHelper.getShortDateString(date: session.topic.startDate))
                    ListItemView(image: "clock", textLeft: "Topic Start Time", textRight: DateHelper.getTimeString(date: session.topic.startDate))
                    ListItemView(image: "clock.fill", textLeft: "Topic End Time", textRight: DateHelper.getTimeString(date: session.topic.endDate))
                }
                
                
                Section(header: Text("Actions")) {
                    if(viewModel.sessionCompleted) {
                        Button(action: { viewModel.incompleteSession() }) {
                            Text("Incomplete Session")
                                .foregroundColor(.blue)
                        }
                    }
                    else {
                        Button(action: { viewModel.completeSession() }) {
                            Text("Complete Session")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
        
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle(session.name)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            viewModel.movingToBackground()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            viewModel.movingToForeground()
        }

    }
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        
        let context = PersistenceController.preview.container.viewContext
        let fetchRequest: NSFetchRequest<Session> = NSFetchRequest(entityName: "Session")
        let sessions = try! context.fetch(fetchRequest)
        
        SessionView(session: sessions[0])
    }
}
