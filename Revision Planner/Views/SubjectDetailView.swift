//
//  SubjectDetailView.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 23/08/2021.
//

import SwiftUI
import CoreData
import MobileCoreServices

struct SubjectDetailView: View {
    
    @ObservedObject private var viewModel: SubjectDetailViewModel
    @State private var showCalendarName: Bool = false
    
    var subject: Subject
    
    init(subject: Subject) {
        self.subject = subject
        self.viewModel = SubjectDetailViewModel(subject: subject)
    }
    
    var body: some View {
        VStack {
            List {
                Section(
                    header: Picker("", selection: $viewModel.displayMode, content: {
                        Text("Week").tag(0)
                        Text("Total").tag(1)
                        
                    })
                    .pickerStyle(SegmentedPickerStyle()),
                    footer: VStack(alignment: .center, spacing: 25) {
                        Spacer()
                        
                        if(viewModel.displayMode == 0) {
                            CircularProgressView(progress: viewModel.percentageCompleteThisWeek, progressText: "\(Int(viewModel.percentageCompleteThisWeek * 100))%")
                                .frame(width: 200, height: 200)
                          
                            Text("\(viewModel.completedSessionsThisWeek)/\(viewModel.totalSessionsThisWeek) sessions completed this week")
                            
                        }
                        else {
                            CircularProgressView(progress: viewModel.percentageComplete, progressText: "\(Int(viewModel.percentageComplete * 100))%")
                                .frame(width: 200, height: 200)
                          
                            Text("\(viewModel.completedSessions)/\(viewModel.totalSessions) sessions completed overall")

                        }
                        
                        VStack(spacing: 6) {
                            
                            if(viewModel.totalSessionsThisWeek == 0) {
                                Text("UPCOMING SESSIONS")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.bottom, 5)
                                ForEach(viewModel.upcomingSessions, id:\.self) { session in
                                    SessionCardView(subject: session.topic.subject.name, title: session.name, time: DateHelper.humanOffsetFromNow(date: session.startDate))
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            viewModel.selectedSession = session
                                            viewModel.openSessionPage = true
                                        }
                                }
                            }
                            else {
                                Text("SESSIONS THIS WEEK")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.bottom, 5)
                                ForEach(viewModel.thisWeeksSessions, id:\.self) { session in
                                    SessionCardView(subject: session.topic.subject.name, title: session.name, time: DateHelper.humanOffsetFromNow(date: session.startDate))
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            viewModel.selectedSession = session
                                            viewModel.openSessionPage = true
                                        }
                                }
                            }
                        }
                    }
                ) {}
                .padding(.bottom, 15)
                .alert(isPresented: $viewModel.showWeekEmpty) {
                    Alert(title: Text("Alert"), message: Text("No sessions in the upcoming week"))
                }

                
                Section(header: Text("General")) {
                    ListItemView(image: "info.circle", textLeft: "Name", textRight: subject.name)
                    ListItemView(image: "calendar", textLeft: "Calendar Name", textRight: "Show", textRightColor: .secondary)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            showCalendarName = true
                        }
                    ListItemView(image: "stopwatch", textLeft: "Session Length (min)", textRight: String(subject.sessionLength))
                    NavigationLink(destination: TopicsView(subject: subject)){
                        ListItemView(image: "folder", textLeft: "Topics")
                    }
                }
                .alert(isPresented: $showCalendarName) {
                    Alert(title: Text("Calendar Name"), message: Text(subject.calendarName()), primaryButton: .default(Text("Ok")), secondaryButton: .destructive(Text("Copy"),
                          action: {
                            UIPasteboard.general.setValue(subject.calendarName(),
                                        forPasteboardType: kUTTypePlainText as String)
                          }
                    ))
                }
                
                Section(header: Text("Times")) {
                    ListItemView(image: "calendar.badge.plus", textLeft: "Start Date", textRight: DateHelper.getShortDateString(date: subject.startDate))
                    ListItemView(image: "calendar.badge.minus", textLeft: "End Date", textRight: DateHelper.getShortDateString(date: subject.endDate))
                    ListItemView(image: "clock", textLeft: "Start Time", textRight: DateHelper.getTimeString(date: subject.startTime))
                    ListItemView(image: "clock.fill", textLeft: "End Time", textRight: DateHelper.getTimeString(date: subject.endTime))
                }
            }
            .background(
                NavigationLink(destination: SubjectsView(), isActive: $viewModel.openSubjectsPage, label: {
                    EmptyView()
                })
            )
        }
        .navigationTitle(subject.name)
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(InsetGroupedListStyle())
        .background(
            NavigationLink(destination: SessionView(session: viewModel.selectedSession), isActive: $viewModel.openSessionPage, label: {
                EmptyView()
            })
        )
        .onAppear() {
            self.viewModel.performCalculations()
        }
    }
}

struct SubjectDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let fetchRequest: NSFetchRequest<Subject> = NSFetchRequest(entityName: "Subject")
        let subjects = try! context.fetch(fetchRequest)
        
        SubjectDetailView(subject: subjects[5])
    }
}

