//
//  SessionView.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 25/08/2021.
//

import SwiftUI
import CoreData


struct CircularProgressView: View {

    var progress: Double
    var progressText: String
    var color: Color = Color.orange


    var body: some View {
        
        if(progressText != "Completed") {
            ZStack {
                Circle()
                    .stroke(Color(.systemGray4), lineWidth: 5)
                Circle()
                    .trim(from: 0, to: CGFloat(self.progress))
                    .stroke(
                        color,
                        style: StrokeStyle(lineWidth: 5, lineCap: .round
                        )
                    )
            }
            .rotationEffect(Angle(degrees: 270))
            .overlay(
                Text(progressText).font(Font.largeTitle.monospacedDigit())
            )
        }
        else {
                ZStack {
                    Circle()
                        .stroke(Color(.systemGray4), lineWidth: 5)
                    Circle()
                        .trim(from: 0, to: CGFloat(self.progress))
                        .stroke(
                            color,
                            style: StrokeStyle(lineWidth: 5, lineCap: .round
                            )
                        )
                }
                .rotationEffect(Angle(degrees: 270))
                .overlay(
                    Label("Completed", systemImage: "checkmark.circle").font(.title3)
            )
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
                        
                        if(viewModel.sessionCompleted) {
                            CircularProgressView(progress: 1, progressText: "Completed", color: Color.green)
                                .animation(.linear)
                                .aspectRatio(contentMode: .fit)
                        }
                        else {
                            if(viewModel.timer == nil) {
                                CircularProgressView(
                                    progress: viewModel.timeRemainingPerc,
                                    progressText: DateHelper.secondsToHoursMinutesSeconds(seconds: viewModel.timeRemainingSeconds)
                                )
                                .animation(.linear)
                                .aspectRatio(contentMode: .fit)
     
                            }
                            else {
                                CircularProgressView(progress: viewModel.timeRemainingPerc, progressText: DateHelper.secondsToHoursMinutesSeconds(seconds: viewModel.timeRemainingSeconds))
                                    .animation(.linear)
                                    .aspectRatio(contentMode: .fit)
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
                    Button(action: {}) {
                        Text("Reschedule")
                            .foregroundColor(.blue)
                    }
                    Button(action: {}) {
                        Text("Delete Session")
                            .foregroundColor(.red)
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
