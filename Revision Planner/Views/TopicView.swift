//
//  TopicView.swift
//  Revision Planner
//
//  Created by Matthew Lewis on 28/08/2021.
//

import SwiftUI
import CoreData

struct TopicView: View {
    
    var topic: Topic
    @State var sessions: [Session]
    
    @ObservedObject private var viewModel: TopicViewModel
    
    init(topic: Topic) {
        self.topic = topic
        self.viewModel = TopicViewModel(topic: self.topic)
        self.sessions = SessionStorage.shared.fetchByTopic(topic: topic)
    }
    
    func deleteSession(indexSet: IndexSet) {
        for index in indexSet {
            SessionStorage.shared.delete(id: sessions[index].id)
            self.sessions = SessionStorage.shared.fetchByTopic(topic: topic)

        }
    }
    
    var body: some View {
        VStack {
            List {
                Section(header: Text("General")) {
                    ListItemView(image: "info.circle", textLeft: "Name", textRight: viewModel.topic.name)
                    ListItemView(image: "calendar.badge.plus", textLeft: "Date", textRight: DateHelper.getShortDateString(date: viewModel.topic.startDate))
                    ListItemView(image: "clock", textLeft: "Start Time", textRight: DateHelper.getTimeString(date: viewModel.topic.startDate))
                    ListItemView(image: "clock.fill", textLeft: "End Time", textRight: DateHelper.getTimeString(date: viewModel.topic.endDate))
                    ListItemView(image: "info.circle", textLeft: "Subject", textRight: viewModel.topic.subject.name)
                }
                
               
                Section(header:
                    HStack {
                        Text("Details")
                        Spacer()
                        Button(action: { viewModel.openTextAlert = true }) {
                           Text("EDIT")
                        }
                    }
                ) {
                    if(viewModel.topic.details != nil) {
                        Text(viewModel.topic.details!)
                    } else {
                        Text("No topic details provided.")
                    }
                }
                
                
                Section(header: Text("Sessions")) {
                    if(self.sessions.count == 0) {
                        Text("No sessions")
                    } else {
                        ForEach(self.sessions, id: \.self) { session in
                            NavigationLink(destination: SessionView(session: session)) {
                                Text(session.name)
                            }
                        }
                        .onDelete(perform: deleteSession)
                    }
                }
            }
        }
        .onAppear() {
            self.sessions = SessionStorage.shared.fetchByTopic(topic: topic)
        }
        .navigationTitle(Text(topic.name))
        .listStyle(InsetGroupedListStyle())
        .textFieldAlert(isShowing: $viewModel.openTextAlert, text: $viewModel.details, title: "Change Topic Details")
    }
}

struct TopicView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let fetchRequest: NSFetchRequest<Topic> = NSFetchRequest(entityName: "Topic")
        let topics = try! context.fetch(fetchRequest)
        
        TopicView(topic: topics[0])
    }
}
